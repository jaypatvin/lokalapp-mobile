import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/shop/user_shop.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/inputs/search_text_field.dart';
import '../../../widgets/persistent_header_delegate_builder.dart';
import '../../../widgets/products_sliver_grid.dart';
import 'components/shop_header.dart';
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
    final _searchController = useTextEditingController();
    final _shops = useMemoized(() => context.read<Shops>());
    final _products = useMemoized(() => context.read<Products>());

    useEffect(
      () {
        void _listener() {
          vm.onSearchTermChanged(_searchController.text);
        }

        _searchController.addListener(_listener);
        _products.addListener(vm.updateProducts);

        return () => _products.removeListener(vm.updateProducts);
      },
      [_searchController, vm],
    );

    useEffect(
      () {
        _shops.addListener(vm.refresh);
        return () => _shops.removeListener(vm.refresh);
      },
      [vm],
    );

    final _slivers = useMemoized<List<Widget>>(
      () {
        if (vm.products.isEmpty && (vm.searchTerm?.isNotEmpty ?? false)) {
          return [
            SliverFillRemaining(
              child: Center(
                child: Text('No products with term: ${vm.searchTerm}'),
              ),
            ),
          ];
        }
        return [
          if (vm.products.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0.h),
                child: Text(
                  'No products added',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0.sp,
                  ),
                ),
              ),
            ),
          if (vm.isCurrentUser)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0.h),
                child: AppButton.transparent(
                  text: '+ Add a new Product',
                  onPressed: vm.addProduct,
                ),
              ),
            ),
          ProductsSliverGrid(
            items: vm.products,
            onProductTap: vm.onProductTap,
            valueKeyPrefix: 'user_shop',
          ),
        ];
      },
      [vm.products],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: 180.0.h,
            pinned: true,
            floating: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final _collapsed = constraints.biggest.height ==
                    MediaQuery.of(context).padding.top + kToolbarHeight;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    vm.shop.name!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: _collapsed ? kNavyColor : Colors.white,
                        ),
                  ),
                  background: SafeArea(
                    child: ShopHeader(
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
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: UserBanner(
              displayName: vm.user.displayName!,
              profilePhoto: vm.user.profilePhoto,
              onTap: vm.goToProfile,
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeaderDelegateBuilder(
              maxHeight: 65.0.h,
              minHeight: 65.0.h,
              child: Container(
                height: 65.0.h,
                padding: EdgeInsets.fromLTRB(8.0.w, 10.0.h, 8.0.w, 5.0.h),
                color: Colors.white,
                child: SearchTextField(
                  enabled: true,
                  controller: _searchController,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          ..._slivers,
        ],
      ),
    );
  }
}
