import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          productPrice.toString(),
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: kOrangeColor,
                fontSize: 26.0.sp,
                fontWeight: FontWeight.w600,
              ),
        )
      ],
    );
  }
}
