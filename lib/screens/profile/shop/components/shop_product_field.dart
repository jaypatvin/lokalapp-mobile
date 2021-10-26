import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/products.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/shop/components/shop_product_field.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/products_list.dart';

class ShopProductField extends StatelessWidget {
  const ShopProductField({
    Key? key,
    required this.userId,
    this.shopId,
  }) : super(key: key);
  final String userId;
  final String? shopId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<Products, ShopProductFieldViewModel>(
      create: (ctx) => ShopProductFieldViewModel(
        ctx,
        userId,
        context.read<Products>().items,
        shopId,
      )..init(),
      update: (ctx, products, vm) => vm!..updateProducts(products.items),
      builder: (ctx, _) {
        return Consumer<ShopProductFieldViewModel>(
          builder: (ctx2, vm, _) {
            if (vm.products.isEmpty) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "No products added",
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
                        "ADD PRODUCTS",
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
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  if (vm.isCurrentUser)
                    AppButton(
                      "+ Add a new Product",
                      kTealColor,
                      false,
                      vm.addProduct,
                    ),
                  ProductsList(
                    items: vm.products.toList(),
                    onProductTap: vm.onProductTap,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
