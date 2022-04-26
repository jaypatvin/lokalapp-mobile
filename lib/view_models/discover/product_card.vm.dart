import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/failure_exception.dart';
import '../../models/post_requests/shared/application_log.dart';
import '../../models/product.dart';
import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../services/application_logger.dart';
import '../../state/view_model.dart';

class ProductCardViewModel extends ViewModel {
  ProductCardViewModel({required this.productId});
  final String productId;

  bool _displayBorder = false;
  bool get displayBorder => _displayBorder;

  late Product product;
  late Shop shop;

  String? get productImage => product.gallery?.firstOrNull?.url;
  String get productName => product.name;
  String get productPrice => product.basePrice.toStringAsFixed(2);
  String get productRating => product.avgRating.toStringAsFixed(2);

  bool get isLiked => product.likes.contains(context.read<Auth>().user?.id);

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    product = context.read<Products>().findById(productId)!;
    shop = context.read<Shops>().findById(product.shopId)!;
    _displayBorder = context.read<ShoppingCart>().contains(productId);
  }

  void updateDisplayBorder({required bool displayBorder}) {
    _displayBorder = displayBorder;
    notifyListeners();
  }

  void onProductsUpdate() {
    product = context.read<Products>().findById(productId)!;
    shop = context.read<Shops>().findById(product.shopId)!;
    notifyListeners();
  }

  void onLike() {
    try {
      if (isLiked) {
        context.read<Products>().unlikeProduct(
              productId: productId,
              userId: context.read<Auth>().user!.id,
            );
        showToast('Unliked!');
      } else {
        context
          ..read<Products>().likeProduct(
            productId: productId,
            userId: context.read<Auth>().user!.id,
          )
          ..read<ApplicationLogger>().log(
            actionType: ActionTypes.productLike,
            metaData: {
              'product_id': product.id,
              'shop_id': shop.id,
            },
          );

        showToast('Liked!');
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  void onShopTap() {
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.userShop,
      arguments: UserShopArguments(
        userId: product.userId,
        shopId: product.shopId,
      ),
    );
  }
}
