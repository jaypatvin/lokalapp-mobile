import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/shops.dart';
import '../screens/profile/components/product_card.dart';

class ProductsList extends StatelessWidget {
  ProductsList({
    required this.items,
    required this.onProductTap,
    this.crossAxisCount = 2,
  });
  final int crossAxisCount;
  final List<Product> items;
  final void Function(String) onProductTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2 / 3,
        crossAxisCount: this.crossAxisCount,
      ),
      itemBuilder: (ctx2, index) {
        try {
          final shops = context.read<Shops>();
          final productImage = items[index]
              .gallery
              ?.firstWhereOrNull((gallery) => gallery.url.isNotEmpty);
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: 5.0.h,
              horizontal: 2.5.w,
            ),
            child: GestureDetector(
              onTap: () => onProductTap(items[index].id),
              child: ProductCard(
                productId: items[index].id,
                name: items[index].name,
                imageUrl: productImage?.url ?? '',
                price: items[index].basePrice,
                shopName: shops.findById(items[index].shopId)!.name,
                shopImageUrl: shops.findById(items[index].shopId)!.profilePhoto,
              ),
            ),
          );
        } catch (e) {
          return Container();
        }
      },
    );
  }
}
