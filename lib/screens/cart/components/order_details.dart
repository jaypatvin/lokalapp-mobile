import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
        if (product.gallery?.isNotEmpty ?? false)
          SizedBox(
            width: 67,
            height: 67,
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
              errorWidget: (ctx, url, err) =>
                  const Center(child: Text('Error displaying image.')),
            ),
          )
        else
          SizedBox(
            width: 67,
            height: 67,
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
        const SizedBox(width: 15),
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
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  const SizedBox(width: 16.0),
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
                            .subtitle2
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
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
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
