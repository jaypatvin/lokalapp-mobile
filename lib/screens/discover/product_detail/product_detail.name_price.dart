import 'package:flutter/material.dart';

import '../../../utils/constants/themes.dart';

class ProductItemAndPrice extends StatelessWidget {
  final String? productName;
  final double? productPrice;
  const ProductItemAndPrice({
    Key? key,
    required this.productName,
    required this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            productName!,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Text(
          productPrice?.toStringAsFixed(2) ?? 'Error fetching price',
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: kOrangeColor, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
