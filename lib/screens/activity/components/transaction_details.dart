import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    final _name = useMemoized<String?>(
      () => isBuyer
          ? transaction.shop.name
          : Provider.of<Users>(context, listen: false)
              .findById(transaction.buyerId)
              ?.displayName,
    );

    final _displayPhoto = useMemoized<String?>(
      () => isBuyer
          ? Provider.of<Shops>(context, listen: false)
              .findById(transaction.shopId)
              ?.profilePhoto
          : Provider.of<Users>(context, listen: false)
              .findById(transaction.buyerId)
              ?.profilePhoto,
    );

    final _price = useMemoized<double>(
      () => transaction.products
          .fold(0.0, (double prev, product) => prev + product.price),
    );

    final _displayStatus = useMemoized<String?>(
      () => (transaction.statusCode == 300 &&
              transaction.paymentMethod == PaymentMethod.cod)
          ? 'Cash on Delivery'
          : status,
    );

    final _avatar = useMemoized<Row>(() {
      return Row(
        children: [
          ChatAvatar(
            displayName: _name,
            displayPhoto: _displayPhoto,
            radius: 15.0.r,
          ),
          SizedBox(width: 5.0.w),
          Expanded(
            child: Text(
              _name ?? '',
              style: Theme.of(context).textTheme.bodyText1,
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
                      _displayStatus!,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  : _avatar,
            ),
            Text(
              'For ',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              DateFormat.MMMd().format(transaction.deliveryDate),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        SizedBox(height: 10.0.h),
        if (status?.isNotEmpty ?? false) _avatar,
        if (status?.isNotEmpty ?? false) SizedBox(height: 10.0.h),
        ListView.builder(
          // this shrinkWrap is okay since there is only 1 (or a few) product
          // per transaction
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transaction.products.length,
          itemBuilder: (ctx, index) {
            final item = transaction.products[index];
            final product =
                Provider.of<Products>(context, listen: false).findById(item.id);

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (product?.gallery?.isNotEmpty ?? false)
                    Image.network(
                      product!.gallery!.first.url,
                      width: 40.0.h,
                      height: 40.0.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Text('Error displaying Image')),
                    )
                  else
                    SizedBox(
                      height: 40.0.h,
                      width: 40.0.h,
                      child: const Center(
                        child: Text('No image'),
                      ),
                    ),
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'x${item.quantity}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'P ${item.quantity * item.price}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10.0.h),
        const Divider(
          color: Colors.grey,
          indent: 0,
        ),
        SizedBox(height: 10.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Order Total ',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'P $_price',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: kOrangeColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        )
      ],
    );
  }
}
