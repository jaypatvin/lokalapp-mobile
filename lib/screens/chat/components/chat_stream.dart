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
import '../../../routers/app_router.dart';
import '../../../routers/chat/props/chat_view.props.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/chat/chat_stream.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/inputs/search_text_field.dart';
import '../chat_view.dart';
import 'chat_avatar.dart';

class ChatStream extends StatelessWidget {
  const ChatStream({
    Key? key,
    required this.chatStream,
  }) : super(key: key);
  final Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ChatStreamView(),
      viewModel: ChatStreamViewModel(chatStream),
    );
  }
}

class _ChatStreamView extends StatelessView<ChatStreamViewModel> {
  @override
  Widget render(BuildContext context, ChatStreamViewModel vm) {
    // the user chat stream is always not null, it can only be empty so no need
    // for additional checks
    if (vm.chatStream == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have not created a shop yet!'),
          SizedBox(height: 5.0.h),
          AppButton.transparent(
            text: 'Create Shop',
            color: kPurpleColor,
            onPressed: vm.createShopHandler,
          ),
        ],
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: vm.chatStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Lottie.asset(kAnimationLoading));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "It's lonely here. No Chats yet!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0.w, 10.0.h, 8.0.w, 0.0),
                child: SearchTextField(
                  hintText: 'Search Chats',
                  enabled: true,
                  onChanged: vm.onSearchQueryChanged,
                ),
              ),
            ),
            _ChatList(chats: vm.getChats(snapshot)),
          ],
        );
      },
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({Key? key, required this.chats}) : super(key: key);
  final List<ChatModel> chats;

  Container _buildCircleAvatar(List<ChatMember> members) {
    final multUsers = members.length > 1;
    return Container(
      height: 45.0.h,
      width: 45.0.w,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: multUsers ? Alignment.bottomLeft : Alignment.center,
        children: List<Widget>.generate(members.length, (index) {
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

  Widget _itemBuilder(BuildContext context, int index) {
    final cUserId = context.read<Auth>().user!.id;
    final chat = chats[index];
    final members = <ChatMember>[];

    String? title = chat.title;

    if (chat.chatType == ChatType.shop) {
      final shop = context.read<Shops>().findById(chat.shopId)!;
      if (shop.userId == cUserId) {
        final ids = [...chat.members];
        ids.retainWhere((id) => shop.id != id);
        members.addAll(
          ids.map((id) {
            final user = context.read<Users>().findById(id)!;
            return ChatMember(
              displayName: user.displayName ?? '${user.firstName} ${user.lastName}',
              displayPhoto: user.profilePhoto,
              type: chat.chatType,
            );
          }).toList(),
        );
        final memberNames = members.map((user) => user.displayName).toList();
        title = memberNames.join(', ');
      } else {
        members.add(
          ChatMember(
            displayName: shop.name,
            displayPhoto: shop.profilePhoto,
            type: chat.chatType,
          ),
        );
      }
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

      members.addAll(
        ids.map((id) {
          final user = context.read<Users>().findById(id)!;
          return ChatMember(
            displayName: user.displayName ?? '${user.firstName} ${user.lastName}',
            displayPhoto: user.profilePhoto,
            type: chat.chatType,
          );
        }).toList(),
      );

      final memberNames = members.map((user) => user.displayName).toList();
      title = memberNames.join(', ');
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.r),
      child: GestureDetector(
        onTap: () {
          context.read<AppRouter>().navigateTo(
                AppRoute.chat,
                ChatView.routeName,
                arguments: ChatViewProps(createMessage: false, chat: chat),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        _itemBuilder,
        childCount: chats.length,
      ),
    );
  }
}
