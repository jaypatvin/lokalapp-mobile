import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokalapp/routers/profile/user_shop.props.dart';
import 'package:lokalapp/screens/profile/shop/user_shop.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../providers/auth.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_expansion_tile.dart' as custom;
import '../profile/profile_screen.dart';
import 'components/chat_avatar.dart';
import 'shared_media.dart';

class ChatProfile extends StatefulWidget {
  static const routeName = '/chat/view/profile';
  const ChatProfile(this.chat, this.conversations);

  final ChatModel? chat;
  final List<QueryDocumentSnapshot>? conversations;

  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  final _members = <ChatMember>[];

  @override
  void initState() {
    super.initState();

    final userId = context.read<Auth>().user!.id;
    switch (widget.chat!.chatType) {
      case ChatType.user:
        final index = widget.chat!.members.indexOf(userId!);
        widget.chat!.members
          ..removeAt(index)
          ..insert(0, userId)
          ..forEach((id) {
            final user =
                Provider.of<Users>(context, listen: false).findById(id)!;
            _members.add(
              ChatMember(
                displayName: user.displayName,
                id: user.id,
                displayPhoto: user.profilePhoto,
                type: ChatType.user,
              ),
            );
          });
        break;
      case ChatType.shop:
      case ChatType.product:
        final user = context.read<Auth>().user!;
        final shop = Provider.of<Shops>(context, listen: false)
            .findById(widget.chat!.shopId)!;
        _members.addAll([
          ChatMember(
            displayName: user.displayName,
            id: user.id,
            displayPhoto: user.profilePhoto,
            type: ChatType.user,
          ),
          ChatMember(
            displayName: shop.name,
            id: shop.id,
            displayPhoto: shop.profilePhoto,
            type: ChatType.shop,
          ),
        ]);
        break;
      default:
        break;
    }
  }

  Widget buildTitle() {
    final names = <String?>[];
    final userId = context.read<Auth>().user!.id;
    _members.forEach((user) {
      if (user.id == userId)
        names.add("You");
      else
        names.add(user.displayName);
    });

    final title = names.join(", ");
    return Text(
      title,
      style: Theme.of(context).textTheme.headline5!.copyWith(color: kNavyColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        leadingColor: Colors.black,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.0.h,
              child: ListView.builder(
                itemCount: _members.length,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final displayName = _members[index].displayName;
                  final imgUrl = _members[index].displayPhoto ?? "";
                  return ChatAvatar(
                    displayName: displayName,
                    displayPhoto: imgUrl,
                    radius: 120.0.r / _members.length,
                  );
                },
              ),
            ),
            SizedBox(height: 10.0.h),
            Center(
              child: buildTitle(),
            ),
            ListTileTheme(
              minVerticalPadding: 0,
              textColor: Colors.black,
              child: custom.ExpansionTile(
                headerBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                iconColor: kTealColor,
                title: Text(
                  "Chat Members",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                children: [
                  ListView.builder(
                    itemCount: _members.length,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      final user = _members[index];
                      final displayName =
                          user.displayName! + (index == 0 ? " (You)" : "");
                      return ListTile(
                        onTap: () {
                          if (user.id == context.read<Auth>().user!.id) {
                            ctx.read<AppRouter>().jumpToTab(AppRoute.profile);
                            return;
                          }
                          if (user.type == ChatType.shop) {
                            final shop = ctx.read<Shops>().findById(user.id);
                            ctx.read<AppRouter>().navigateTo(
                                  AppRoute.profile,
                                  UserShop.routeName,
                                  arguments: UserShopProps(
                                    shop!.userId!,
                                    user.id,
                                  ),
                                );
                            return;
                          }
                          ctx.read<AppRouter>().navigateTo(
                            AppRoute.profile,
                            ProfileScreen.routeName,
                            arguments: {'userId': user.id!},
                          );
                        },
                        leading: ChatAvatar(
                          displayName: user.displayName,
                          displayPhoto: user.displayPhoto,
                          radius: 25.0,
                        ),
                        title: Text(displayName),
                      );
                    },
                  )
                ],
              ),
            ),
            ListTileTheme(
              iconColor: kTealColor,
              minVerticalPadding: 0,
              child: ListTile(
                title: Text(
                  "Shared Media",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(MdiIcons.chevronRight),
                  onPressed: () {
                    context.read<AppRouter>().navigateTo(
                      AppRoute.chat,
                      SharedMedia.routeName,
                      arguments: {'conversations': widget.conversations},
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
