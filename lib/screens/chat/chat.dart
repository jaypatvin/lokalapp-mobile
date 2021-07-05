import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/product.dart';
import '../../models/user_shop.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../providers/users.dart';
import '../../services/database.dart';
import '../../utils/shared_preference.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import 'chat_helpers.dart';
import 'chat_view.dart';

class _ChatAvatar {
  final String displayName;
  final String profilePhoto;

  const _ChatAvatar(this.displayName, this.profilePhoto);
}

class Chat extends StatefulWidget {
  const Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with AfterLayoutMixin<Chat> {
  final TextEditingController _searchController = TextEditingController();
  final _userSharedPreferences = UserSharedPreferences();

  @override
  void initState() {
    super.initState();

    _userSharedPreferences.init();
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

  Widget buildUserAvatar(_ChatAvatar user, {double radius = 25.0}) {
    final imgUrl = user.profilePhoto ?? "";
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[600]),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: imgUrl.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imgUrl),
                  ),
                ),
              )
            : Text(user.displayName[0]),
      ),
    );
  }

  Widget buildCircleAvatar(List<_ChatAvatar> members) {
    final multUsers = members.length > 1;
    return Container(
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: multUsers ? Alignment.bottomLeft : Alignment.center,
        children: new List<Widget>.generate(members.length, (index) {
          if (multUsers) {
            return Positioned(
              top: 15.0 * index - 2.5 * members.length,
              right: 15.0 * index - 2.5 * members.length,
              child: buildUserAvatar(members[index],
                  radius: 45.0 / members.length),
            );
          } else {
            return Positioned.fill(child: buildUserAvatar(members[index]));
          }
        }),
      ),
    );
  }

  Widget buildChatList(AsyncSnapshot<QuerySnapshot> conversations) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: conversations.data.docs.length,
      itemBuilder: (ctx, index) {
        final cUserId = Provider.of<CurrentUser>(context, listen: false).id;
        final document = {
          ...conversations.data.docs[index].data(),
          "id": conversations.data.docs[index].id,
        };
        final chat = ChatModel.fromMap(document);
        final members = <_ChatAvatar>[];

        // ShopModel shop;
        // Product product;
        String title = chat.title;

        // if (chat.shopId != null && chat.shopId.isNotEmpty) {
        //   shop =
        //       Provider.of<Shops>(context, listen: false).findById(chat.shopId);
        //   members.add(_ChatAvatar(shop.name, shop.profilePhoto));
        // }
        // if (chat.productId != null && chat.productId.isNotEmpty) {
        //   product = Provider.of<Products>(context, listen: false)
        //       .findById(chat.productId);
        //   members.clear();
        //   members.add(_ChatAvatar(product.name, product.productPhoto));
        // }

        if (chat.chatType == ChatType.shop) {
          final shop =
              Provider.of<Shops>(context, listen: false).findById(chat.shopId);
          members.add(_ChatAvatar(shop.name, shop.profilePhoto));
        } else if (chat.chatType == ChatType.product) {
          final product = Provider.of<Products>(context, listen: false)
              .findById(chat.productId);
          members.add(_ChatAvatar(product.name, product.gallery[0].url));
        } else {
          final ids = chat.members..retainWhere((id) => cUserId != id);

          members.addAll(ids.map((id) {
            final user =
                Provider.of<Users>(context, listen: false).findById(id);
            return _ChatAvatar(user.displayName, user.profilePhoto);
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
                  chatDocument: conversations.data.docs[index],
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

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      appBar: customAppBar(
        titleText: "Chats",
        titleStyle: kTextStyle.copyWith(color: kNavyColor, fontSize: 24.0),
        backgroundColor: kYellowColor,
        buildLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            buildSearchTextField(),
            StreamBuilder<QuerySnapshot>(
              stream: Database.instance.getUserChats(currentUser.id),
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
      ),
    );
  }
}
