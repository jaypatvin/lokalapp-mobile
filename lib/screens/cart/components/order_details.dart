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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Goldplay",
                        fontWeight: FontWeight.w700,
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
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
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
    );
  }
}
