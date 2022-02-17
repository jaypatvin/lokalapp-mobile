import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/chat_model.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_expansion_tile.dart' as custom;
import '../discover/product_detail.dart';
import '../profile/profile_screen.dart';
import '../profile/shop/user_shop.dart';
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

    for (final chatMember in widget.chat!.members) {
      final _user = context.read<Users>().findById(chatMember);
      if (_user != null) {
        _members.add(
          ChatMember(
            displayName:
                _user.displayName ?? '${_user.firstName} ${_user.lastName}',
            id: _user.id,
            displayPhoto: _user.profilePhoto,
            type: ChatType.user,
          ),
        );
        continue;
      }

      final _shop = context.read<Shops>().findById(chatMember);
      if (_shop != null) {
        _members.add(
          ChatMember(
            displayName: _shop.name,
            id: _shop.id,
            displayPhoto: _shop.profilePhoto,
            type: ChatType.shop,
          ),
        );
        continue;
      }

      final _product = context.read<Products>().findById(chatMember);
      if (_product != null) {
        _members.add(
          ChatMember(
            displayName: _product.name,
            id: _product.id,
            displayPhoto:
                _product.productPhoto ?? _product.gallery?.firstOrNull?.url,
            type: ChatType.product,
          ),
        );
      }
    }
  }

  Widget buildTitle() {
    final names = <String?>[];
    final userId = context.read<Auth>().user!.id;

    for (final user in _members) {
      if (user.id == userId) {
        names.add('You');
      } else {
        names.add(user.displayName);
      }
    }

    final title = names.join(', ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style:
            Theme.of(context).textTheme.headline6?.copyWith(color: kNavyColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _memberBuilder(BuildContext ctx, int index) {
    final bool _isCurrentUser;
    final _member = _members[index];

    switch (_member.type) {
      case ChatType.user:
        _isCurrentUser = _member.id == ctx.read<Auth>().user?.id;
        break;
      case ChatType.shop:
        final _shop = context.read<Shops>().findById(_member.id);
        _isCurrentUser = _shop?.userId == ctx.read<Auth>().user?.id;
        break;
      case ChatType.product:
        final _product = context.read<Products>().findById(_member.id);
        _isCurrentUser = _product?.userId == ctx.read<Auth>().user?.id;
        break;
    }

    // final displayName = _member.displayName! + (_isCurrentUser ? ' (You)' : '');
    final String displayName;
    if (_isCurrentUser) {
      displayName = '${_member.displayName} (You)';
    } else if (_member.type == ChatType.shop) {
      displayName = '${_member.displayName} (Shop)';
    } else if (_member.type == ChatType.product) {
      displayName = '${_member.displayName} (Product)';
    } else {
      displayName = _member.displayName;
    }

    return ListTile(
      onTap: () {
        if (_member.id == context.read<Auth>().user!.id) {
          ctx.read<AppRouter>().jumpToTab(AppRoute.profile);
          return;
        }
        final appRoute = ctx.read<AppRouter>().currentTabRoute;
        switch (_member.type) {
          case ChatType.user:
            ctx.read<AppRouter>().pushDynamicScreen(
                  appRoute,
                  AppNavigator.appPageRoute(
                    builder: (_) => ProfileScreen(
                      userId: _member.id,
                    ),
                  ),
                );
            break;
          case ChatType.shop:
            final _shop = context.read<Shops>().findById(_member.id);
            ctx.read<AppRouter>().pushDynamicScreen(
                  appRoute,
                  AppNavigator.appPageRoute(
                    builder: (_) => UserShop(
                      userId: _shop!.userId,
                      shopId: _shop.id,
                    ),
                  ),
                );
            break;
          case ChatType.product:
            final _product = context.read<Products>().findById(_member.id)!;
            ctx.read<AppRouter>().navigateTo(
                  AppRoute.discover,
                  ProductDetail.routeName,
                  arguments: ProductDetailProps(_product),
                );
            break;
        }
      },
      leading: ChatAvatar(
        displayName: _member.displayName,
        displayPhoto: _member.displayPhoto,
      ),
      title: Text(displayName),
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
              height: 120.0.r,
              child: CustomScrollView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext ctx, int index) {
                        final displayName = _members[index].displayName;
                        final imgUrl = _members[index].displayPhoto ?? '';
                        return ChatAvatar(
                          displayName: displayName,
                          displayPhoto: imgUrl,
                          radius: 120.0.r / 2,
                        );
                      },
                      childCount: _members.length,
                    ),
                  ),
                ],
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
                title: const Text(
                  'Chat Members',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                children: [
                  ListView.builder(
                    itemCount: _members.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: _memberBuilder,
                  )
                ],
              ),
            ),
            ListTileTheme(
              iconColor: kTealColor,
              minVerticalPadding: 0,
              child: ListTile(
                title: const Text(
                  'Shared Media',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(MdiIcons.chevronRight),
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
