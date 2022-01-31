import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/product.dart';
import '../../../utils/constants/themes.dart';

class OrderDetails extends StatelessWidget {
  final Product product;
  final int quantity;
  final void Function() onEditTap;
  const OrderDetails({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onEditTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (product.gallery != null && product.gallery!.isNotEmpty)
          SizedBox(
            width: 60.0.h,
            height: 60.0.h,
            child: Image(
              image: NetworkImage(product.gallery!.first.url),
              fit: BoxFit.cover,
              errorBuilder: (ctx, obj, stk) => const SizedBox(),
            ),
          ),
        if (product.gallery == null || product.gallery!.isEmpty)
          SizedBox(
            width: 60.0.h,
            height: 60.0.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: const Center(
                child: Text(
                  'No image',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        SizedBox(width: 16.0.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 16.0.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.basePrice.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'x$quantity',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: onEditTap,
                child: Text(
                  'Edit',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w300,
                        decoration: TextDecoration.underline,
                        color: kTealColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
