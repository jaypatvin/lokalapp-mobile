import 'package:collection/collection.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/order.dart';
import '../../../models/post_requests/orders/order_review.request.dart';
import '../../../models/product.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/buyer/review_submitted.dart';
import '../../../services/api/api.dart';
import '../../../services/api/order_api_service.dart';
import '../../../state/view_model.dart';

class ReviewOrderViewModel extends ViewModel {
  ReviewOrderViewModel({required this.order});

  final Order order;
  late final OrderAPIService _orderAPIService;

  final _ratings = <String, int>{};
  final _reviews = <String, String>{};

  late final List<Product> _products;
  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  @override
  void init() {
    _orderAPIService = OrderAPIService(context.read<API>());
    _products = order.productIds
        .map<Product?>((id) => context.read<Products>().findById(id))
        .whereType<Product>()
        .toList();
  }

  Future<void> onSubmitReview() async {
    for (final product in order.products) {
      if (_ratings[product.id] == null) {
        showToast('Please add a rating for ${product.name}.');
        return;
      }
    }
    for (final product in order.products) {
      if (_products.where((item) => product.id == item.id).isEmpty) {
        showToast('Cannot find product: ${product.name}');
        continue;
      }

      final success = await _orderAPIService.addReview(
        productId: product.id,
        orderId: order.id,
        request: OrderReviewRequest(
          rating: _ratings[product.id]!,
          message: _reviews[product.id],
        ),
      );

      if (success) {
        AppRouter.activityNavigatorKey.currentState?.pushReplacement(
          AppNavigator.appPageRoute(
            builder: (_) => const ReviewSubmitted(),
          ),
        );
      }
    }
  }

  void onUpdateRating({required OrderProduct product, required int rating}) {
    _ratings[product.id] = rating;
  }

  void onUpdateReview({required OrderProduct product, required String review}) {
    _reviews[product.id] = review;
  }

  String? getShopId(OrderProduct item) {
    final product =
        _products.firstWhereOrNull((product) => item.id == product.id);

    return context.read<Shops>().findById(product?.shopId)?.name;
  }
}
