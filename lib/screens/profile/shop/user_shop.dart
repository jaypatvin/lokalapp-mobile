import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'components/shop_hours.dart';
import 'components/shop_options.dart';
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
    final searchController = useTextEditingController();
    final shops = useMemoized(() => context.read<Shops>());
    final products = useMemoized(() => context.read<Products>());

    useEffect(
      () {
        void listener() {
          vm.onSearchTermChanged(searchController.text);
        }

        searchController.addListener(listener);
        products.addListener(vm.updateProducts);

        return () => products.removeListener(vm.updateProducts);
      },
      [searchController, vm],
    );

    useEffect(
      () {
        shops.addListener(vm.refresh);
        return () => shops.removeListener(vm.refresh);
      },
      [vm],
    );

    final slivers = useMemoized<List<Widget>>(
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
                padding: const EdgeInsets.only(top: 40, bottom: 12),
                child: Consumer<Products>(
                  builder: (ctx, products, _) {
                    if (products.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kOrangeColor,
                        ),
                      );
                    }
                    return const Text(
                      'No products added',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    );
                  },
                ),
              ),
            ),
          if (vm.isCurrentUser)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                child: AppButton.transparent(
                  text: '+ Add a new Product',
                  onPressed: vm.addProduct,
                ),
              ),
            ),
          ProductsSliverGrid(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            items: vm.products,
            onProductTap: vm.onProductTap,
            valueKeyPrefix: 'user_shop',
            displayError: false,
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
            expandedHeight: 176,
            pinned: true,
            floating: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.biggest.height ==
                    MediaQuery.of(context).padding.top + kToolbarHeight;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    vm.shop.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: collapsed ? kNavyColor : Colors.white,
                        ),
                  ),
                  background: SafeArea(
                    child: ShopHeader(
                      shopName: vm.shop.name,
                      shopProfilePhoto: vm.shop.profilePhoto,
                      shopCoverPhoto: vm.shop.coverPhoto,
                      linearGradientColors: vm.shopHeaderColors,
                      onSettingsTap: vm.isCurrentUser ? vm.onSettingsTap : null,
                      onEditTap: vm.isCurrentUser ? vm.onEditTap : null,
                      onOptionsTap: () => vm.onOptionsTap(
                        options: ShopOptions(
                          onReportShop: () => vm.onReportShop(
                            message: const _ReportShopModalSheet(),
                          ),
                        ),
                      ),
                      onShopPhotoTap: vm.onShopPhotoTap,
                    ),
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: vm.user != null
                ? UserBanner(
                    displayName: vm.user!.displayName,
                    profilePhoto: vm.user!.profilePhoto,
                    onTap: vm.goToProfile,
                  )
                : const SizedBox(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ShopHours(shopOperatingHours: vm.shop.operatingHours),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  vm.shop.description,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 23)),
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeaderDelegateBuilder(
              maxHeight: kMinInteractiveDimension,
              minHeight: kMinInteractiveDimension,
              child: Container(
                height: kMinInteractiveDimension,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: SearchTextField(
                  enabled: true,
                  controller: searchController,
                ),
              ),
            ),
          ),
          // const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ...slivers,
        ],
      ),
    );
  }
}

class _ReportShopModalSheet extends StatelessWidget {
  const _ReportShopModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Report shop?',
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 76),
                child: Text(
                  'Our team will review this shop.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 47),
              Row(
                children: [
                  Expanded(
                    child: AppButton.transparent(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton.filled(
                      text: 'Report',
                      onPressed: () => Navigator.of(context).pop(true),
                      color: kPinkColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
