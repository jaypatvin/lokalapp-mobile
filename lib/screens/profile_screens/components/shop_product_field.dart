import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/add_product_screen/add_product.dart';
import 'package:lokalapp/screens/chat/components/chat_avatar.dart';
import 'package:lokalapp/screens/profile_screens/components/shop_header.dart';
import 'package:lokalapp/screens/profile_screens/components/store_card.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/app_button.dart';
import 'package:lokalapp/widgets/search_text_field.dart';
import 'package:persistent_bottom_nav_bar/models/nested_will_pop_scope.dart';
import 'package:provider/provider.dart';

class ShopProductField extends StatelessWidget {
  const ShopProductField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    final shop = context.read<Shops>().findByUser(user.id).first;

    void _addProductHandler(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProduct(),
        ),
      );
    }

    return Consumer<Products>(
      builder: (ctx, products, child) {
        if (products.findByShop(shop.id).isEmpty) {
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
              ),
            ],
          ),
        );
      },
    );
  }
}
