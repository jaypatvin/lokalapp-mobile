import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../utils/themes.dart';

class PullUpPanelHeader extends StatelessWidget {
  Widget get consumerShoppingCart => Consumer<ShoppingCart>(
        builder: (context, cart, child) {
          var quantity = cart.items.length;
          double price = 0.0;
          cart.items.forEach((key, value) {
            var product =
                Provider.of<Products>(context, listen: false).findById(key);
            price += product.basePrice * value.quantity;
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$quantity item',
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 16,
                  color: kNavyColor,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Subtotal: ',
                      style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 16,
                        color: kNavyColor,
                      ),
                    ),
                    TextSpan(
                      text: 'P$price',
                      style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kNavyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );

  Widget get sizedBox => SizedBox(
        height: 18.0,
      );

  Widget get shoppingCart => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Shopping Cart',
            style: TextStyle(
              fontFamily: "Goldplay",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: kNavyColor,
            ),
          ),
          consumerShoppingCart
        ],
      );

  circularBorder(context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
            height: 5,
            decoration: BoxDecoration(
              color: kNavyColor,
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 40,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFF7A00),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(
                children: [
                  sizedBox,
                  circularBorder(context),
                  sizedBox,
                  shoppingCart,
                  sizedBox
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
