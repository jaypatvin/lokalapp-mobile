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
import '../../widgets/custom_app_bar.dart';
import 'chat_helpers.dart';
import 'chat_view.dart';
import 'components/chat_avatar.dart';



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
