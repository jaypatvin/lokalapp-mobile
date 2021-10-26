import 'package:flutter/material.dart';
import 'package:lokalapp/view_models/profile/shop/user_shop.vm.dart';
import 'package:provider/provider.dart';

import '../../../widgets/inputs/search_text_field.dart';
import 'components/shop_header.dart';
import 'components/shop_product_field.dart';
import 'components/user_banner.dart';

class UserShop extends StatelessWidget {
  const UserShop({
    Key? key,
    required this.userId,
    this.shopId,
  }) : super(key: key);
  final String userId;
  final String? shopId;
  static const String routeName = "/profile/shop";

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (ctx) => UserShopViewModel(ctx, userId, shopId)..init(),
      builder: (ctx, _) {
        final vm = ctx.read<UserShopViewModel>();
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                ShopHeader(
                  shopName: vm.shop.name!,
                  shopProfilePhoto: vm.shop.profilePhoto,
                  shopCoverPhoto: vm.shop.coverPhoto,
                  linearGradientColors: vm.shopHeaderColors,
                  onSettingsTap: vm.onSettingsTap,
                  onEditTap: vm.onEditTap,
                  displayEditButton: vm.displayEditButton,
                  displaySettingsButton: vm.displaySettingsButton,
                ),
                UserBanner(
                  displayName: vm.user.displayName!,
                  profilePhoto: vm.user.profilePhoto,
                  onTap: vm.goToProfile,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        SearchTextField(enabled: false),
                        Center(
                          child: ShopProductField(
                            userId: this.userId,
                            shopId: this.shopId,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
