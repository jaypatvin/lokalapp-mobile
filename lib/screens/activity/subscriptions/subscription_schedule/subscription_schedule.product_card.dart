import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/product.dart';
import '../../../../utils/constants/themes.dart';

class SubscriptionScheduleProductCard extends StatelessWidget {
  /// The product card to be displayed in the [SubscriptionSchedule] screen.
  ///
  /// We can't use the transaction card since we are not using transactions.
  const SubscriptionScheduleProductCard({
    Key? key,
    required this.product,
    required this.quantity,
    this.onEditTap,
  }) : super(key: key);

  final Product product;
  final int quantity;
  final void Function()? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFFE0E0E0),
        ),
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (product.gallery?.isNotEmpty ?? false)
                    SizedBox(
                      width: 80.0.h,
                      height: 80.0.h,
                      child: Image.network(
                        product.gallery!.first.url,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, obj, stack) {
                          return const Text('Error displaying image');
                        },
                      ),
                    )
                  else
                    SizedBox(
                      height: 80.0.h,
                      width: 80.0.h,
                      child: const Center(
                        child: Text('No Image'),
                      ),
                    ),
                  SizedBox(width: 8.0.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            SizedBox(width: 8.0.w),
                            Column(
                              children: [
                                Text(
                                  product.basePrice.toString(),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'x$quantity',
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.h),
                        if (onEditTap != null)
                          InkWell(
                            onTap: onEditTap,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontFamily: 'Goldplay',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
