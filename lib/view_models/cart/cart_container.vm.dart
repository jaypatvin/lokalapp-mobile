import 'package:flutter/cupertino.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';

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
    locator<AppRouter>()
        .navigateTo(AppRoute.discover, DiscoverRoutes.checkoutCart);
  }
}
