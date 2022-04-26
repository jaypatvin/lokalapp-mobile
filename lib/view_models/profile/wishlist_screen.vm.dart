import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../providers/products.dart';
import '../../state/view_model.dart';

class WishlistScreenViewModel extends ViewModel {
  void onProductTap(String id) {
    final product = context.read<Products>().findById(id);
    locator<AppRouter>().navigateTo(
      AppRoute.discover,
      DiscoverRoutes.productDetail,
      arguments: ProductDetailArguments(product: product!),
    );
  }
}
