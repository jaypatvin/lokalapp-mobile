import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
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
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ShopBannerView(),
      viewModel: ShopBannerViewModel(userId: userId),
    );
  }
}

class _ShopBannerView extends HookView<ShopBannerViewModel> {
  @override
  Widget render(BuildContext context, ShopBannerViewModel vm) {
    if (vm.isCurrentUser) {
      return _CurrentUserShopBanner(
        onVerifyPressed: vm.onVerify,
        onAddShop: vm.onAddShop,
        onGoToShop: vm.goToShop,
      );
    } else {
      return Consumer<Shops>(
        builder: (context, shops, _) {
          final _shops = shops.findByUser(vm.userId);
          if (_shops.isEmpty) {
            return const SizedBox.shrink();
          } else {
            final _shop = _shops.first;
            return ShopTile(
              shop: _shop,
              onGoToShop: () => vm.goToShop(_shop),
            );
          }
        },
      );
    }
  }
}

class _CurrentUserShopBanner extends StatelessWidget {
  const _CurrentUserShopBanner({
    Key? key,
    required this.onVerifyPressed,
    required this.onAddShop,
    required this.onGoToShop,
  }) : super(key: key);
  final void Function() onVerifyPressed;
  final void Function() onAddShop;
  final void Function(Shop shop) onGoToShop;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10.0.w, 20.0.w, 10.0.w, 10.0.w),
          width: double.infinity,
          child: const Text(
            'My Shop',
            style: TextStyle(
              color: kTealColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Consumer<Auth>(
          builder: (context, auth, child) {
            final _isUserRegistered =
                auth.user?.registration?.verified ?? false;
            if (!_isUserRegistered &&
                (auth.user?.registration?.idPhoto?.isNotEmpty ?? false)) {
              return GestureDetector(
                onTap: onVerifyPressed,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Verification Pending',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.black),
                      ),
                      Text(
                        'We are currently verifying your account.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!_isUserRegistered) {
              return ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    tileColor: kPinkColor,
                    title: const Text(
                      'Verify Account',
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
                    onTap: onVerifyPressed,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 75.0.w),
                    color: Colors.transparent,
                    child: const Text(
                      'You must verify your account to add a shop',
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

            return Consumer<Shops>(
              builder: (_, shops, __) {
                if (shops.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: LinearProgressIndicator(),
                    ),
                  );
                }

                final _shops = shops.findByUser(auth.user!.id);
                if (_shops.isEmpty) {
                  return Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0.h,
                      horizontal: 5.0.w,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100.0.w),
                      child: AppButton.transparent(
                        text: '+ ADD SHOP',
                        onPressed: onAddShop,
                      ),
                    ),
                  );
                }
                return ShopTile(
                  shop: _shops.first,
                  onGoToShop: () => onGoToShop(_shops.first),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
