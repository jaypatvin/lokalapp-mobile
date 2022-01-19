import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/shops.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../view_models/profile/shop/user_shop.vm.dart';
import '../../../widgets/inputs/search_text_field.dart';
import 'components/shop_header.dart';
import 'components/shop_product_field.dart';
import 'components/user_banner.dart';

class UserShop extends StatelessWidget {
  static const String routeName = '/profile/shop';
  const UserShop({
    Key? key,
    required this.userId,
    this.shopId,
  }) : super(key: key);
  final String userId;
  final String? shopId;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _UserShopView(),
      viewModel: UserShopViewModel(userId, shopId),
    );
  }
}

class _UserShopView extends HookView<UserShopViewModel> {
  @override
  Widget render(BuildContext context, UserShopViewModel vm) {
    final _shops = useMemoized(() => context.read<Shops>());

    useEffect(
      () {
        _shops.addListener(vm.refresh);
        return () => _shops.removeListener(vm.refresh);
      },
      [vm],
    );

    final _searchController = useTextEditingController();

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
              onShopPhotoTap: vm.onShopPhotoTap,
            ),
            UserBanner(
              displayName: vm.user.displayName!,
              profilePhoto: vm.user.profilePhoto,
              onTap: vm.goToProfile,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0.h),
                    child: SearchTextField(
                      enabled: true,
                      controller: _searchController,
                    ),
                  ),
                  Expanded(
                    child: ShopProductField(
                      userId: vm.userId,
                      shopId: vm.shopId,
                      searchController: _searchController,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
