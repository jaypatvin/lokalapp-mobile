import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
    final _auth = useMemoized<Auth>(() => context.read<Auth>(), []);
    final _shops = useMemoized<Shops>(() => context.read<Shops>(), []);

    useEffect(
      () {
        void _listener() {
          vm.refresh();
        }

        _auth.addListener(_listener);
        _shops.addListener(_listener);

        return () {
          _auth.removeListener(_listener);
          _shops.removeListener(_listener);
        };
      },
      [vm],
    );

    final _buildShopBanner = useCallback<StatelessWidget Function()>(
      () {
        if (!vm.isUserRegistered &&
            (vm.user.registration?.idPhoto?.isNotEmpty ?? false)) {
          return GestureDetector(
            onTap: vm.onVerify,
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
        } else if (!vm.isUserRegistered) {
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
                onTap: vm.onVerify,
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

            if (vm.shop == null) {
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
                    onPressed: vm.onAddShop,
                  ),
                ),
              );
            }
            return ShopTile(
              shop: vm.shop!,
              onGoToShop: vm.goToShop,
            );
          },
        );
      },
      [vm],
    );

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
            _buildShopBanner(),
          ],
        );
    }
  }
}
