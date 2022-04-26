import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/app_navigator.dart';
import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../utils/constants/navigation_keys.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_expansion_tile.dart' as custom;
import '../profile/profile_screen.dart';
import '../profile/shop/user_shop.dart';
import 'components/chat_avatar.dart';

class ChatProfile extends StatefulWidget {
  const ChatProfile(this.chat, this.conversations);

  final ChatModel chat;
  final List<Conversation>? conversations;

  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  final _members = <ChatMember>[];

  @override
  void initState() {
    super.initState();

    for (final chatMember in widget.chat.members) {
      final _user = context.read<Users>().findById(chatMember);
      if (_user != null) {
        _members.add(
          ChatMember(
            displayName: _user.displayName.isNotEmpty
                ? _user.displayName
                : '${_user.firstName} ${_user.lastName}',
            id: _user.id,
            displayPhoto: _user.profilePhoto,
            type: MemberType.user,
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
            type: MemberType.shop,
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
            displayPhoto: _product.gallery?.firstOrNull?.url,
            type: MemberType.product,
          ),
        );
      } else {
        _members.add(
          const ChatMember(
            displayName: 'Deleted Product',
            type: MemberType.product,
          ),
        );
      }
    }
  }

  Widget _buildTitle() {
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
      case MemberType.user:
        _isCurrentUser = _member.id == ctx.read<Auth>().user?.id;
        break;
      case MemberType.shop:
        final _shop = context.read<Shops>().findById(_member.id);
        _isCurrentUser = _shop?.userId == ctx.read<Auth>().user?.id;
        break;
      case MemberType.product:
        final _product = context.read<Products>().findById(_member.id);
        _isCurrentUser = _product?.userId == ctx.read<Auth>().user?.id;
        break;
    }

    // final displayName = _member.displayName! + (_isCurrentUser ? ' (You)' : '');
    final String displayName;
    if (_isCurrentUser) {
      displayName = '${_member.displayName} (You)';
    } else if (_member.type == MemberType.shop) {
      displayName = '${_member.displayName} (Shop)';
    } else if (_member.type == MemberType.product) {
      displayName = '${_member.displayName} (Product)';
    } else {
      displayName = _member.displayName;
    }

    return ListTile(
      onTap: () {
        if (_isCurrentUser) {
          switch (_member.type) {
            case MemberType.user:
              ctx
                  .read<PersistentTabController>()
                  .jumpToTab(kProfileNavigationKey);
              break;
            case MemberType.shop:
              final _shop = ctx.read<Shops>().findById(_member.id);
              locator<AppRouter>().navigateTo(
                AppRoute.profile,
                ProfileScreenRoutes.userShop,
                arguments: UserShopArguments(
                  userId: _shop!.userId,
                  shopId: _member.id,
                ),
              );
              break;
            case MemberType.product:
              final _product = ctx.read<Products>().findById(_member.id);
              if (_product == null) {
                showToast('Sorry, product has been deleted');
                break;
              }
              locator<AppRouter>().navigateTo(
                AppRoute.profile,
                ProfileScreenRoutes.addProduct,
                arguments: AddProductArguments(productId: _member.id),
              );
              break;
          }

          return;
        }
        final appRoute = locator<AppRouter>().currentTabRoute;
        switch (_member.type) {
          case MemberType.user:
            locator<AppRouter>().pushDynamicScreen(
              appRoute,
              AppNavigator.appPageRoute(
                builder: (_) => ProfileScreen(
                  userId: _member.id,
                ),
              ),
            );
            break;
          case MemberType.shop:
            final _shop = context.read<Shops>().findById(_member.id);
            locator<AppRouter>().pushDynamicScreen(
              appRoute,
              AppNavigator.appPageRoute(
                builder: (_) => UserShop(
                  userId: _shop!.userId,
                  shopId: _shop.id,
                ),
              ),
            );
            break;
          case MemberType.product:
            final _product = context.read<Products>().findById(_member.id);
            if (_product != null) {
              locator<AppRouter>().navigateTo(
                AppRoute.discover,
                DiscoverRoutes.productDetail,
                arguments: ProductDetailArguments(product: _product),
              );
            } else {
              showToast('Sorry, product has been deleted');
            }
            break;
        }
      },
      leading: ChatAvatar(
        displayName: _member.displayName,
        displayPhoto: _member.displayPhoto,
      ),
      title: Text(
        displayName,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            ?.copyWith(color: Colors.black),
      ),
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
              height: 120.0,
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
                          radius: 120.0 / 2,
                        );
                      },
                      childCount: _members.length,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Center(child: _buildTitle()),
            ListTileTheme(
              minVerticalPadding: 0,
              textColor: Colors.black,
              child: custom.ExpansionTile(
                headerBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                iconColor: kTealColor,
                title: Text(
                  'Chat Members',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black),
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
                title: Text(
                  'Shared Media',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black),
                ),
                onTap: () {
                  locator<AppRouter>().navigateTo(
                    AppRoute.chat,
                    ChatRoutes.sharedMedia,
                    arguments: SharedMediaArguments(
                      conversations: widget.conversations ?? [],
                    ),
                  );
                },
                trailing: const Icon(MdiIcons.chevronRight),
              ),
            )
          ],
        ),
      ),
    );
  }
}
