import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/product_review.dart';
import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../services/database/database.dart';
import '../../state/view_model.dart';

class ViewReviewsViewModel extends ViewModel {
  ViewReviewsViewModel({required this.order});

  final Order order;

  late final Product? product;
  late final Shop? shop;

  @override
  void init() {
    product = context.read<Products>().findById(order.productIds.first);
    if (product != null) {
      shop = context.read<Shops>().findById(product!.shopId);
    } else {
      shop = null;
    }
  }

  Future<Map<String, ProductReview>> fetchOrderReviews() async {
    final _reviews = <String, ProductReview>{};

    for (final id in order.productIds) {
      // We can't fetch reviews for products that cannot be found.
      final reviews =
          await context.read<Database>().products.getProductReviews(id);

      final review = reviews.firstWhereOrNull(
        (review) => review.userId == context.read<Auth>().user?.id,
      );

      if (review != null) _reviews[id] = review;
    }

    return _reviews;
  }
}
