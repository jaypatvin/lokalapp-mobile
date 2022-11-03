import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../models/order.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../utils/constants/themes.dart';
import '../../chat/components/chat_avatar.dart';

class TransactionDetails extends HookWidget {
  final Order transaction;
  final String? status;
  final bool isBuyer;

  const TransactionDetails({
    this.status = '',
    required this.transaction,
    required this.isBuyer,
  });

  @override
  Widget build(BuildContext context) {
    final name = useMemoized<String?>(
      () => isBuyer
          ? transaction.shop.name
          : Provider.of<Users>(context, listen: false)
              .findById(transaction.buyerId)
              ?.displayName,
    );

    final displayPhoto = useMemoized<String?>(
      () => isBuyer
          ? Provider.of<Shops>(context, listen: false)
              .findById(transaction.shopId)
              ?.profilePhoto
          : Provider.of<Users>(context, listen: false)
              .findById(transaction.buyerId)
              ?.profilePhoto,
    );

    final price = useMemoized<double>(
      () => transaction.products
          .fold(0.0, (double prev, product) => prev + product.price),
    );

    final displayStatus = useMemoized<String?>(
      () => (transaction.statusCode == 300 &&
              transaction.paymentMethod == PaymentMethod.cod)
          ? 'Cash on Delivery'
          : status,
    );

    final avatar = useMemoized<Row>(() {
      return Row(
        children: [
          ChatAvatar(
            displayName: name,
            displayPhoto: displayPhoto,
            radius: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name ?? '',
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: status?.isNotEmpty ?? false
                  ? Text(
                      displayStatus!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.black),
                    )
                  : avatar,
            ),
            Text(
              'For ',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.black),
            ),
            Text(
              DateFormat.MMMd().format(transaction.deliveryDate),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        if (status?.isNotEmpty ?? false) avatar,
        if (status?.isNotEmpty ?? false) const SizedBox(height: 12.0),
        SizedBox(
          height: 47.0 * transaction.products.length,
          child: ListView.builder(
            // this shrinkWrap is okay since there is only 1 (or a few) product
            // per transaction
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transaction.products.length,
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, index) {
              final item = transaction.products[index];
              final product = Provider.of<Products>(context, listen: false)
                  .findById(item.id);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (product?.gallery?.isNotEmpty ?? false)
                      CachedNetworkImage(
                        imageUrl: product!.gallery!.first.url,
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => const Center(
                          child: Text(
                            'Error displaying Image',
                          ),
                        ),
                      )
                    else
                      const SizedBox(
                        height: 38,
                        width: 38,
                        child: Center(
                          child: Text('No image'),
                        ),
                      ),
                    Text(
                      item.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      'P ${item.quantity * item.price}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        const Divider(
          color: Colors.grey,
          indent: 0,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Order Total ',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.black),
            ),
            Text(
              'P $price',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: kOrangeColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        )
      ],
    );
  }
}
