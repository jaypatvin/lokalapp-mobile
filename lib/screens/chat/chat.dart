import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../providers/users.dart';
import '../../services/database.dart';
import '../../utils/shared_preference.dart';
import '../../utils/themes.dart';
import 'chat_helpers.dart';
import 'chat_view.dart';
import 'components/chat_avatar.dart';

class Chat extends StatefulWidget {
  static const routeName = "/chat";
  const Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>
    with TickerProviderStateMixin, AfterLayoutMixin<Chat> {
  TabController _tabController;

  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  final TextEditingController _searchController = TextEditingController();
  final _userSharedPreferences = UserSharedPreferences();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _tabController.addListener(_tabSelectionHandler);
    _colorAnimation = ColorTween(
      begin: kTealColor,
      end: kPurpleColor,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _userSharedPreferences.init();
  }

  void _tabSelectionHandler() {
    setState(() {
      switch (_tabController?.index) {
        case 0:
          _animationController.reverse();
          break;
        case 1:
          _animationController.forward();
          break;
      }
    });
  }

  Widget _tabChild({
    @required String imgUrl,
    @required String name,
    @required int index,
  }) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ChatAvatar(
            displayName: name,
            displayPhoto: imgUrl,
            radius: index == _tabController?.index ? 25.0 : 15.0,
          ),
          SizedBox(width: width * 0.03),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _userSharedPreferences.isChat
        ? Container()
        : Provider.of<ChatHelpers>(context, listen: false).showAlert(context);
    setState(() {
      _userSharedPreferences.isChat = true;
    });
  }

  @override
  dispose() {
    _userSharedPreferences?.dispose();
    super.dispose();
  }

  Widget buildSearchTextField() {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 65,
      child: TextField(
        enabled: false,
        controller: _searchController,
        decoration: InputDecoration(
          isDense: true, // Added this
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
          ),
          fillColor: Color(0xffF2F2F2),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xffBDBDBD),
            size: 23,
          ),
          hintText: 'Search Chats',
          labelStyle: TextStyle(fontSize: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 1),
          hintStyle: TextStyle(color: Color(0xffBDBDBD)),
        ),
      ),
    );
  }

  Widget buildCircleAvatar(List<ChatMember> members) {
    final multUsers = members.length > 1;
    return Container(
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: multUsers ? Alignment.bottomLeft : Alignment.center,
        children: new List<Widget>.generate(members.length, (index) {
          final member = members[index];
          if (multUsers) {
            return Positioned(
              top: 15.0 * index - 2.5 * members.length,
              right: 15.0 * index - 2.5 * members.length,
              child: ChatAvatar(
                displayName: member.displayName,
                displayPhoto: member.displayPhoto,
                radius: 45.0 / members.length,
              ),
            );
          } else {
            return Positioned.fill(
              child: ChatAvatar(
                displayName: member.displayName,
                displayPhoto: member.displayPhoto,
              ),
            );
          }
        }),
      ),
    );
  }

  Widget buildChatList(AsyncSnapshot<QuerySnapshot> chatSnapshot) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: chatSnapshot.data.docs.length,
      itemBuilder: (ctx, index) {
        final cUserId = Provider.of<CurrentUser>(context, listen: false).id;
        final document = {
          ...chatSnapshot.data.docs[index].data(),
          "id": chatSnapshot.data.docs[index].id,
        };
        final chat = ChatModel.fromMap(document);
        final members = <ChatMember>[];

        String title = chat.title;

        if (chat.chatType == ChatType.shop) {
          final shop =
              Provider.of<Shops>(context, listen: false).findById(chat.shopId);
          members.add(ChatMember(
            displayName: shop.name,
            displayPhoto: shop.profilePhoto,
            type: chat.chatType,
          ));
        } else if (chat.chatType == ChatType.product) {
          final product = Provider.of<Products>(context, listen: false)
              .findById(chat.productId);
          members.add(ChatMember(
            displayName: product.name,
            displayPhoto: product.gallery[0].url,
            type: chat.chatType,
          ));
        } else {
          final ids = [...chat.members];
          ids.retainWhere((id) => cUserId != id);

          members.addAll(ids.map((id) {
            final user =
                Provider.of<Users>(context, listen: false).findById(id);
            return ChatMember(
              displayName: user.displayName,
              displayPhoto: user.profilePhoto,
              type: chat.chatType,
            );
          }).toList());

          final memberNames = members.map((user) => user.displayName).toList();
          title = memberNames.join(", ");
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatView(
                  false,
                  chat: chat,
                ),
              ),
            );
          },
          child: ListTile(
            leading: buildCircleAvatar(members),
            title: Text(title),
            subtitle: Text(chat.lastMessage.content),
            trailing: Text(DateFormat.jm().format(chat.lastMessage.createdAt)),
          ),
        );
      },
    );
  }

  Widget getChats(String id) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          buildSearchTextField(),
          StreamBuilder<QuerySnapshot>(
            stream: Database.instance.getUserChats(id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: buildChatList(snapshot),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    final shop = context.read<Shops>().findByUser(user.id).first;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ChatAppBar(
        height: size.height * 0.15,
        backgroundColor: _colorAnimation.value,
        bottom: PreferredSize(
          preferredSize: Size(size.width, size.height * 0.075),
          child: Container(
            padding: EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white.withOpacity(0.5),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                //indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                ),
                tabs: [
                  _tabChild(
                    imgUrl: user.profilePhoto,
                    name: user.displayName,
                    index: 0,
                  ),
                  _tabChild(
                    imgUrl: shop.profilePhoto,
                    name: shop.name,
                    index: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          getChats(user.id),
          getChats(shop.id),
        ],
      ),
    );
  }
}

class ChatAppBar extends PreferredSize {
  final double height;
  final Color backgroundColor;
  final PreferredSizeWidget bottom;
  const ChatAppBar({
    Key key,
    this.height = 50.0,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Chats",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Goldplay",
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: this.backgroundColor,
      bottom: this.bottom,
    );
  }
}
