import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/chat_model.dart';
import '../../models/conversation.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../routers/profile/props/user_shop.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_expansion_tile.dart' as custom;
import '../discover/product_detail.dart';
import '../profile/add_product/add_product.dart';
import '../profile/profile_screen.dart';
import '../profile/shop/user_shop.dart';
import 'components/chat_avatar.dart';
import 'shared_media.dart';

class ChatProfile extends StatefulWidget {
  static const routeName = '/chat/view/profile';
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
      final user = context.read<Users>().findById(chatMember);
      if (user != null) {
        _members.add(
          ChatMember(
            displayName: user.displayName.isNotEmpty
                ? user.displayName
                : '${user.firstName} ${user.lastName}',
            id: user.id,
            displayPhoto: user.profilePhoto,
            type: MemberType.user,
          ),
        );
        continue;
      }

      final shop = context.read<Shops>().findById(chatMember);
      if (shop != null) {
        _members.add(
          ChatMember(
            displayName: shop.name,
            id: shop.id,
            displayPhoto: shop.profilePhoto,
            type: MemberType.shop,
          ),
        );
        continue;
      }

      final product = context.read<Products>().findById(chatMember);
      if (product != null) {
        _members.add(
          ChatMember(
            displayName: product.name,
            id: product.id,
            displayPhoto: product.gallery?.firstOrNull?.url,
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
    final bool isCurrentUser;
    final member = _members[index];

    switch (member.type) {
      case MemberType.user:
        isCurrentUser = member.id == ctx.read<Auth>().user?.id;
        break;
      case MemberType.shop:
        final shop = context.read<Shops>().findById(member.id);
        isCurrentUser = shop?.userId == ctx.read<Auth>().user?.id;
        break;
      case MemberType.product:
        final product = context.read<Products>().findById(member.id);
        isCurrentUser = product?.userId == ctx.read<Auth>().user?.id;
        break;
    }

    // final displayName = _member.displayName! + (_isCurrentUser ? ' (You)' : '');
    final String displayName;
    if (isCurrentUser) {
      displayName = '${member.displayName} (You)';
    } else if (member.type == MemberType.shop) {
      displayName = '${member.displayName} (Shop)';
    } else if (member.type == MemberType.product) {
      displayName = '${member.displayName} (Product)';
    } else {
      displayName = member.displayName;
    }

    return ListTile(
      onTap: () {
        if (isCurrentUser) {
          switch (member.type) {
            case MemberType.user:
              ctx.read<AppRouter>().jumpToTab(AppRoute.profile);
              break;
            case MemberType.shop:
              final shop = ctx.read<Shops>().findById(member.id);
              ctx.read<AppRouter>().navigateTo(
                    AppRoute.profile,
                    UserShop.routeName,
                    arguments: UserShopProps(shop!.userId, member.id),
                  );
              break;
            case MemberType.product:
              final product = ctx.read<Products>().findById(member.id);
              if (product == null) {
                showToast('Sorry, product has been deleted');
                break;
              }
              ctx.read<AppRouter>().navigateTo(
                AppRoute.profile,
                AddProduct.routeName,
                arguments: {'productId': member.id},
              );
              break;
          }

          return;
        }
        final appRoute = ctx.read<AppRouter>().currentTabRoute;
        switch (member.type) {
          case MemberType.user:
            ctx.read<AppRouter>().pushDynamicScreen(
                  appRoute,
                  AppNavigator.appPageRoute(
                    builder: (_) => ProfileScreen(
                      userId: member.id,
                    ),
                  ),
                );
            break;
          case MemberType.shop:
            final shop = context.read<Shops>().findById(member.id);
            ctx.read<AppRouter>().pushDynamicScreen(
                  appRoute,
                  AppNavigator.appPageRoute(
                    builder: (_) => UserShop(
                      userId: shop!.userId,
                      shopId: shop.id,
                    ),
                  ),
                );
            break;
          case MemberType.product:
            final product = context.read<Products>().findById(member.id);
            if (product != null) {
              ctx.read<AppRouter>().navigateTo(
                    AppRoute.discover,
                    ProductDetail.routeName,
                    arguments: ProductDetailProps(product),
                  );
            } else {
              showToast('Sorry, product has been deleted');
            }
            break;
        }
      },
      leading: ChatAvatar(
        displayName: member.displayName,
        displayPhoto: member.displayPhoto,
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
                  context.read<AppRouter>().navigateTo(
                    AppRoute.chat,
                    SharedMedia.routeName,
                    arguments: {'conversations': widget.conversations},
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
