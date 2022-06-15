import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../models/order.dart';
import '../models/shop.dart';

class ProductReviewCard extends StatelessWidget {
  const ProductReviewCard({
    Key? key,
    required this.orderProduct,
    this.shop,
  }) : super(key: key);

  final OrderProduct orderProduct;
  final Shop? shop;

  @override
  Widget build(BuildContext context) {
    final review = orderProduct.review!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (orderProduct.image.isNotEmpty)
              SizedBox(
                width: 50,
                height: 50,
                child: CachedNetworkImage(
                  imageUrl: orderProduct.image,
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
                width: 50,
                height: 50,
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderProduct.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shop?.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      RatingBarIndicator(
                        itemBuilder: (ctx, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 16,
                        rating: review.rating.toDouble(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    (review.message?.isNotEmpty ?? false)
                        ? review.message!
                        : 'No review included',
                    style: review.message?.isNotEmpty ?? false
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.black)
                        : Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: const Color(0xFF828282),
                              fontStyle: FontStyle.italic,
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
