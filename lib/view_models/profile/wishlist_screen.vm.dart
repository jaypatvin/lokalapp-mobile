import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../screens/discover/product_detail.dart';
import '../../state/view_model.dart';

class WishlistScreenViewModel extends ViewModel {
  void onProductTap(String id) {
    final product = context.read<Products>().findById(id);
    context.read<AppRouter>()
      ..navigateTo(
        AppRoute.discover,
        ProductDetail.routeName,
        arguments: ProductDetailProps(product!),
      );
  }
}
