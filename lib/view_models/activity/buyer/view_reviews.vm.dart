import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../models/shop.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../services/api/api.dart';
import '../../../state/view_model.dart';

class ViewReviewsViewModel extends ViewModel {
  ViewReviewsViewModel({required this.order});

  final Order order;

  late final Product? product;
  late final Shop? shop;
  late final OrderAPI _apiService;

  @override
  void init() {
    _apiService = locator<OrderAPI>();
    product = context.read<Products>().findById(order.productIds.first);
    if (product != null) {
      shop = context.read<Shops>().findById(product!.shopId);
    } else {
      shop = null;
    }
  }

  Future<List<OrderProduct>> fetchOrderReviews() async {
    return _apiService.getOrderProductsReviews(orderId: order.id);
  }
}
