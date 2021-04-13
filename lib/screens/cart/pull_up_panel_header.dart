import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../utils/themes.dart';

class PullUpPanelHeader extends StatelessWidget {
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
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
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
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
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
                      Consumer<ShoppingCart>(
                        builder: (context, cart, child) {
                          var quantity = cart.items.length;
                          double price = 0.0;
                          for (var item in cart.items) {
                            var id = item['product'];
                            var product =
                                Provider.of<Products>(context, listen: false)
                                    .findById(id);
                            price += product.basePrice * item['quantity'];
                          }
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
