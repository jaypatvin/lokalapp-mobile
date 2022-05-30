import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

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
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2 / 3,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 24,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (ctx2, index) {
        try {
          return GestureDetector(
            key: ValueKey(items[index].id),
            onTap: () => onProductTap(items[index].id),
            child: ProductCard(items[index].id),
          );
        } catch (e, stack) {
          FirebaseCrashlytics.instance.recordError(e, stack);
          return const SizedBox();
        }
      },
    );
  }
}
