import 'package:provider/provider.dart';

import '../../models/product_review.dart';
import '../../providers/products.dart';
import '../../services/api/product_api_service.dart';
import '../../state/view_model.dart';

class ProductReviewsViewModel extends ViewModel {
  ProductReviewsViewModel({required this.productId});
  final String productId;

  late final ProductApiService _apiService;

  @override
  void init() {
    _apiService = context.read<Products>().api;
  }

  Future<List<ProductReview>> fetchReviews() async {
    return _apiService.getReviews(productId: productId);
  }
}
