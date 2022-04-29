import '../../app/app.locator.dart';
import '../../models/product_review.dart';
import '../../services/api/api.dart';
import '../../state/view_model.dart';

class ProductReviewsViewModel extends ViewModel {
  ProductReviewsViewModel({required this.productId});
  final String productId;

  final _apiService = locator<ProductAPI>();

  Future<List<ProductReview>> fetchReviews() async {
    return _apiService.getReviews(productId: productId);
  }
}
