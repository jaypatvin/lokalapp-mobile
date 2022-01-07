import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/products.dart';
import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/shop/components/shop_product_field.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/products_list.dart';

class ShopProductField extends StatelessWidget {
  const ShopProductField({
    Key? key,
    required this.userId,
    this.shopId,
    this.searchController,
  }) : super(key: key);
  final String userId;
  final String? shopId;
  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ShopProductFieldView(
        searchController: searchController,
      ),
      viewModel: ShopProductFieldViewModel(
        userId: userId,
        shopId: shopId,
      ),
    );
    //   return ChangeNotifierProxyProvider<Products, ShopProductFieldViewModel>(
    //     create: (ctx) => ShopProductFieldViewModel(
    //       userId,
    //       context.read<Products>().items,
    //       shopId,
    //     )..init(),
    //     update: (ctx, products, vm) => vm!..updateProducts(products.items),
    //     builder: (ctx, _) {
    //       return Consumer<ShopProductFieldViewModel>(
    //         builder: (ctx2, vm, _) {
    //           if (vm.products.isEmpty) {
    //             return Container(
    //               width: MediaQuery.of(context).size.width * 0.5,
    //               child: ListView(
    //                 shrinkWrap: true,
    //                 children: [
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     "No products added",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       color: Colors.grey,
    //                       fontWeight: FontWeight.w500,
    //                       fontSize: 14.0.sp,
    //                     ),
    //                   ),
    //                   SizedBox(height: 10.0.h),
    //                   if (vm.isCurrentUser)
    //                     AppButton(
    //                       "ADD PRODUCTS",
    //                       kTealColor,
    //                       true,
    //                       vm.addProduct,
    //                     ),
    //                 ],
    //               ),
    //             );
    //           }

    //           return Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 8.0.w),
    //             child: ListView(
    //               physics: NeverScrollableScrollPhysics(),
    //               shrinkWrap: true,
    //               children: [
    //                 if (vm.isCurrentUser)
    //                   AppButton(
    //                     "+ Add a new Product",
    //                     kTealColor,
    //                     false,
    //                     vm.addProduct,
    //                   ),
    //                 ProductsList(
    //                   items: vm.products.toList(),
    //                   onProductTap: vm.onProductTap,
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   );
  }
}

class _ShopProductFieldView extends HookView<ShopProductFieldViewModel> {
  const _ShopProductFieldView({
    Key? key,
    this.searchController,
  }) : super(key: key);

  final TextEditingController? searchController;
  @override
  Widget render(BuildContext context, ShopProductFieldViewModel vm) {
    final _products = useMemoized<Products>(() => context.read<Products>());

    useEffect(
      () {
        void _listener() {
          vm.onSearchTermChanged(searchController?.text);
        }

        searchController?.addListener(_listener);
        _products.addListener(vm.updateProducts);

        return () => _products.removeListener(vm.updateProducts);
      },
      [searchController, vm],
    );
    if (vm.products.isEmpty && (vm.searchTerm?.isNotEmpty ?? false)) {
      return Center(
        child: Text('No products with term: ${vm.searchTerm}'),
      );
    } else if (vm.products.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 10),
            Text(
              'No products added',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14.0.sp,
              ),
            ),
            SizedBox(height: 10.0.h),
            if (vm.isCurrentUser)
              AppButton(
                'ADD PRODUCTS',
                kTealColor,
                true,
                vm.addProduct,
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          if (vm.isCurrentUser)
            AppButton(
              '+ Add a new Product',
              kTealColor,
              false,
              vm.addProduct,
            ),
          ProductsList(
            items: [...vm.products],
            onProductTap: vm.onProductTap,
          ),
        ],
      ),
    );
  }
}
