import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/chat_model.dart';
import '../../../providers/auth.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/inputs/search_text_field.dart';
import '../chat_view.dart';
import 'chat_avatar.dart';

class ChatStream extends StatelessWidget {
  final Stream<QuerySnapshot>? chatStream;
  final TextEditingController searchController;
  const ChatStream({
    Key? key,
    required this.chatStream,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0.h),
          SearchTextField(
            controller: searchController,
            hintText: "Search Chats",
          ),
          StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Lottie.asset(kAnimationLoading));
              }
              if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
                return Padding(
                  padding: EdgeInsets.only(top: 24.0.h),
                  child: Text(
                    "It's lonely here. No Chats yet!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return _ChatList(chatSnapshot: snapshot);
            },
          ),
        ],
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot>? chatSnapshot;
  const _ChatList({
    Key? key,
    this.chatSnapshot,
  }) : super(key: key);

  Widget _buildCircleAvatar(List<ChatMember> members) {
    final multUsers = members.length > 1;
    return Container(
      height: 45.0.h,
      width: 45.0.w,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: multUsers ? Alignment.bottomLeft : Alignment.center,
        children: new List<Widget>.generate(members.length, (index) {
          final member = members[index];
          if (multUsers) {
            return Positioned(
              top: 13.0.h * index - 2.5 * members.length,
              right: 13.0.w * index - 2.5 * members.length,
              child: ChatAvatar(
                displayName: member.displayName,
                displayPhoto: member.displayPhoto,
                radius: 40.0.r / members.length,
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(5.0.r),
      shrinkWrap: true,
      itemCount: chatSnapshot!.data!.docs.length,
      itemBuilder: (ctx, index) {
        final cUserId = context.read<Auth>().user!.id;
        final snapshotData =
            chatSnapshot!.data!.docs[index].data() as Map<String, dynamic>;
        final document = {
          ...snapshotData,
          "id": chatSnapshot!.data!.docs[index].id,
        };
        final chat = ChatModel.fromMap(document);
        final members = <ChatMember>[];

        String? title = chat.title;

        if (chat.chatType == ChatType.shop) {
          final shop = context.read<Shops>().findById(chat.shopId)!;
          members.add(ChatMember(
            displayName: shop.name,
            displayPhoto: shop.profilePhoto,
            type: chat.chatType,
          ));
        } else if (chat.chatType == ChatType.product) {
          final product = context.read<Products>().findById(chat.productId);
          members.add(
            ChatMember(
              displayName: product!.name,
              displayPhoto: product.gallery![0].url,
              type: chat.chatType,
            ),
          );
        } else {
          final ids = [...chat.members];
          ids.retainWhere((id) => cUserId != id);

          members.addAll(ids.map((id) {
            final user = context.read<Users>().findById(id);
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
            leading: _buildCircleAvatar(members),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.0.sp,
              ),
            ),
            subtitle: Text(
              chat.lastMessage.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0.sp,
              ),
            ),
            trailing: Text(DateFormat.jm().format(chat.lastMessage.createdAt)),
          ),
        );
      },
    );
  }
}
