import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/cart/cart_container.vm.dart';

/// Handles the FAB of the shopping cart found throughout the app
class CartContainer extends StatelessWidget {
  /// The `Container` that will display the FAB Cart.
  const CartContainer({
    Key? key,
    required this.child,
    this.alwaysDisplayButton = false,
  }) : super(key: key);

  /// The underlying screen/widget behind the cart button
  final Widget child;

  /// Overrides the button display condition.
  ///
  /// Will display the button irrespective of the number of items in the cart.
  final bool alwaysDisplayButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        child,
        ChangeNotifierProxyProvider<ShoppingCart, CartContainerViewModel>(
          create: (_) => CartContainerViewModel(
            context,
            alwaysDisplayButton: alwaysDisplayButton,
          ),
          update: (ctx, cart, vm) {
            final quantity = cart.orders.values
                .map<int>((orders) => orders.length)
                .fold<int>(0, (a, b) => a + b);
            return vm!..updateCartLength(quantity);
          },
          builder: (ctx, _) {
            return Consumer<CartContainerViewModel>(
              builder: (ctx2, vm, _) {
                return Visibility(
                  visible: vm.displayButton,
                  child: Positioned(
                    right: 20.0,
                    bottom: 20.0,
                    child: FloatingActionButton(
                      backgroundColor: kYellowColor,
                      onPressed: vm.onPressed,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            vm.numberOfItems,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: kNavyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
