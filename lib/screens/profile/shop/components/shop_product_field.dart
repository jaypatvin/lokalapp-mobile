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
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Column(
        children: [
          if (vm.products.isEmpty)
            Padding(
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
          if (vm.isCurrentUser)
            Padding(
              padding: EdgeInsets.only(bottom: 10.0.h),
              child: AppButton(
                '+ Add a new Product',
                kTealColor,
                false,
                vm.addProduct,
              ),
            ),
          Expanded(
            child: ProductsList(
              items: [...vm.products],
              onProductTap: vm.onProductTap,
            ),
          ),
        ],
      ),
    );
  }
}
