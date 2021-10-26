import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../add_product/add_product.dart';
import 'store_card.dart';

class ShopProductField extends StatelessWidget {
  const ShopProductField({Key? key}) : super(key: key);

  void _addProductHandler(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProduct(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<Auth>().user!;
    final shop = context.read<Shops>().findByUser(user.id).first;

    return Consumer<Products>(
      builder: (ctx, products, child) {
        if (products.findByShop(shop.id!).isEmpty) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListView(
              shrinkWrap: true,
              children: [
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
                AppButton(
                  "ADD PRODUCTS",
                  kTealColor,
                  true,
                  () => _addProductHandler(context),
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
              AppButton(
                "+ Add a new Product",
                kTealColor,
                false,
                () => _addProductHandler(context),
              ),
              StoreCard(
                crossAxisCount: 2,
                isUserProducts: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
