import 'package:flutter/material.dart';

import '../../../models/product.dart';
import '../../../utils/themes.dart';

class OrderDetails extends StatelessWidget {
  final Product product;
  final int quantity;
  final void Function() onEditTap;
  const OrderDetails({
    Key key,
    @required this.product,
    @required this.quantity,
    @required this.onEditTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 70.00,
                    height: 60.00,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(product.gallery.first.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "GoldplayBold",
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Goldplay",
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                            color: kTealColor,
                          ),
                        ),
                        onTap: onEditTap,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(height: 60.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'x$quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "GoldplayBold",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        // padding: const EdgeInsets.all(0.0),
                        child: Text(
                          product.basePrice.toString(),
                          // textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "GoldplayBold",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
