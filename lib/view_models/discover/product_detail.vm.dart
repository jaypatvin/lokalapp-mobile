import 'package:flutter/cupertino.dart';
import 'package:lokalapp/models/user_shop.dart';

import '../../models/product.dart';
import '../../providers/cart.dart';
import '../../state/view_model.dart';

class ProductDetailViewModel extends ViewModel {
  ProductDetailViewModel({
    required this.product,
    required this.cart,
    required this.shop,
  });

  final ShoppingCart cart;
  final Product product;
  final ShopModel shop;

  late final String appBarTitle;
  late final String buttonLabel;

  String _instructions = '';
  String get instructions => _instructions;

  int _quantity = 0;
  int get quantity => _quantity;

  @override
  void init() {
    super.init();
    if (cart.contains(product.id)) {
      final order = cart.getProductOrder(product.id)!;
      this._instructions = order.notes ?? '';
      this._quantity = order.quantity;
      this.appBarTitle = 'Edit Order';
      this.buttonLabel = 'UPDATE CART';
    } else {
      this.appBarTitle = shop.name!;
      this.buttonLabel = 'ADD TO CART';
    }
  }

  void onInstructionsChanged(String value) {
    _instructions = value;
    notifyListeners();
  }

  void increase() {
    this._quantity++;
    notifyListeners();
  }

  void decrease() {
    if (quantity <= 0) return;
    this._quantity--;
    notifyListeners();
  }

  void onSubmit() {
    cart.add(
      shopId: product.shopId,
      productId: product.id,
      quantity: _quantity,
      notes: _instructions,
    );
    Navigator.pop(context);
  }
}
