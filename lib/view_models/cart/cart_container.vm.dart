import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../routers/app_router.dart';
import '../../screens/cart/checkout_cart.dart';

class CartContainerViewModel extends ChangeNotifier {
  CartContainerViewModel(
    this.context, {
    this.alwaysDisplayButton = false,
  });

  final BuildContext context;
  final bool alwaysDisplayButton;

  int _cartitems = 0;

  bool get displayButton => alwaysDisplayButton || _cartitems > 0;
  String get numberOfItems => _cartitems.toString();

  void updateCartLength(int quantity) {
    _cartitems = quantity;
    notifyListeners();
  }

  void onPressed() {
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          CheckoutCart.routeName,
        );
  }
}
