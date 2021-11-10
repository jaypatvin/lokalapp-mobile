import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/components/shop_banner.vm.dart';
import '../../../widgets/app_button.dart';
import 'shop_tile.dart';

class ShopBanner extends StatelessWidget {
  const ShopBanner({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  Widget _buildShopBanner(ShopBannerViewModel vm) {
    if (!vm.isUserRegistered) {
      return ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            tileColor: kPinkColor,
            title: Text(
              "Verify Account",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14.0.r,
            ),
            onTap: vm.onVerify,
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 75.0.w),
            color: Colors.transparent,
            child: Text(
              "You must verify your account to add a shop",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPinkColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 5.0.h),
        ],
      );
    }

    if (vm.shop == null) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 10.0.h,
          horizontal: 5.0.w,
        ),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 100.0.w,
            child: AppButton(
              "+ ADD SHOP",
              kTealColor,
              false,
              vm.onAddShop,
            ),
          ),
        ),
      );
    }
    return ShopTile(
      shop: vm.shop!,
      onGoToShop: vm.goToShop,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<Auth, Shops, ShopBannerViewModel>(
      create: (ctx) => ShopBannerViewModel(context, userId)..init(),
      update: (ctx, auth, shops, vm) => vm!..refresh(),
      builder: (ctx, _) {
        return Consumer<ShopBannerViewModel>(
          builder: (ctx2, vm, _) {
            switch (vm.mode) {
              case ShopBannerMode.otherUserNoShop:
                return const SizedBox();
              case ShopBannerMode.otherUserWithShop:
                return ShopTile(shop: vm.shop!, onGoToShop: vm.goToShop);
              case ShopBannerMode.currentUser:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(10.0.w, 20.0.w, 10.0.w, 10.0.w),
                      width: double.infinity,
                      child: Text(
                        "My Shop",
                        style: TextStyle(
                          color: kTealColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildShopBanner(vm),
                  ],
                );
            }
          },
        );
      },
    );
  }
}
