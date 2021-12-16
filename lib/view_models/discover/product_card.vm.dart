import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../models/user_shop.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../routers/profile/user_shop.props.dart';
import '../../screens/profile/shop/user_shop.dart';
import '../../state/view_model.dart';

class ProductCardViewModel extends ViewModel {
  ProductCardViewModel({required this.productId});
  final String productId;

  bool _displayBorder = false;
  bool get displayBorder => _displayBorder;

  late Product product;
  late ShopModel shop;

  String? get productImage =>
      product.productPhoto ?? product.gallery?.first.url;
  String get productName => product.name;
  String get productPrice => product.basePrice.toString();
  String get productRating => product.avgRating.toString();

  bool get isLiked => product.likes.contains(context.read<Auth>().user!.id);

  @override
  void init() {
    product = context.read<Products>().findById(productId)!;
    shop = context.read<Shops>().findById(product.shopId)!;
  }

  void updateDisplayBorder(bool displayBorder) {
    this._displayBorder = displayBorder;
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
              userId: context.read<Auth>().user!.id!,
            );
        showToast('Unliked!');
      } else {
        context.read<Products>().likeProduct(
              productId: productId,
              userId: context.read<Auth>().user!.id!,
            );
        showToast('Liked!');
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  void onShopTap() {
    context.read<AppRouter>()
      ..navigateTo(
        AppRoute.profile,
        UserShop.routeName,
        arguments: UserShopProps(product.userId, product.shopId),
      );
  }
}
