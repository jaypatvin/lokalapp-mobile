import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';
import '../screens/profile/components/product_card.dart';

class ProductsSliverGrid extends StatelessWidget {
  const ProductsSliverGrid({
    required this.items,
    required this.onProductTap,
    this.crossAxisCount = 2,
    this.valueKeyPrefix,
  });
  final int crossAxisCount;
  final List<Product> items;
  final void Function(String) onProductTap;
  final String? valueKeyPrefix;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'There are no products yet.',
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          try {
            final _prefix = valueKeyPrefix ?? const Uuid();
            return SizedBox(
              key: ValueKey('${_prefix}_${items[index].id}'),
              child: GestureDetector(
                onTap: () => onProductTap(items[index].id),
                child: ProductCard(items[index].id),
              ),
            );
          } catch (e, stack) {
            FirebaseCrashlytics.instance.recordError(e, stack);
            return const SizedBox();
          }
        },
        childCount: items.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2 / 3,
        crossAxisCount: 2,
        mainAxisSpacing: 24.0,
        crossAxisSpacing: 8,
      ),
    );
  }
}
