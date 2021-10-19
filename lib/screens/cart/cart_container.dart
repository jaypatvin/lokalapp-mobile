import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../utils/themes.dart';
import 'checkout_cart.dart';

/// Handles the FAB of the shopping cart found throughout the app
class CartContainer extends StatelessWidget {
  /// The underlying screen/widget behind the cart button
  final Widget child;

  /// Overrides the button display condition.
  ///
  /// Will display the button irrespective of the number of items in the cart.
  final bool displayButton;
  const CartContainer({
    Key? key,
    required this.child,
    this.displayButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        this.child,
        Consumer<ShoppingCart>(
          builder: (ctx, cart, _) {
            return Visibility(
              visible: cart.orders.isNotEmpty || displayButton,
              child: Positioned(
                right: 20.0,
                bottom: 20.0,
                child: FloatingActionButton(
                  backgroundColor: kYellowColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cart.orders.length.toString(),
                        style: TextStyle(
                          color: kNavyColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: kNavyColor,
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutCart()),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
