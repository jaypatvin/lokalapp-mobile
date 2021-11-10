import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../screens/profile/components/product_card.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({
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
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: 5.0.h,
              horizontal: 2.5.w,
            ),
            child: GestureDetector(
              onTap: () => onProductTap(items[index].id),
              child: ProductCard(items[index].id),
            ),
          );
        } catch (e) {
          return const SizedBox();
        }
      },
    );
  }
}
