import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (product.gallery?.isNotEmpty ?? false)
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CachedNetworkImage(
                        imageUrl: product.gallery!.first.url,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        errorWidget: (ctx, url, error) {
                          return const Text('Error displaying image');
                        },
                      ),
                    )
                  else
                    const SizedBox(
                      height: 70,
                      width: 70,
                      child: Center(
                        child: Text('No Image'),
                      ),
                    ),
                  const SizedBox(width: 8.0),
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
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  product.basePrice.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                        color: const Color(0xFF828282),
                                      ),
                                ),
                                Text(
                                  'x$quantity',
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        if (onEditTap != null)
                          InkWell(
                            onTap: onEditTap,
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Goldplay',
                                fontWeight: FontWeight.w400,
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
