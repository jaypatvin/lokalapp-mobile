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
    this.status = "",
    required this.transaction,
    required this.isBuyer,
  });

  @override
  Widget build(BuildContext context) {
    final _name = useMemoized<String?>(
      () => isBuyer
          ? transaction.shopName
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
      () => this
          .transaction
          .products
          .fold(0.0, (double prev, product) => prev + product.price!),
    );

    final _displayStatus = useMemoized<String?>(
      () =>
          (transaction.statusCode == 300 && transaction.paymentMethod == 'cod')
              ? 'Cash on Delivery'
              : this.status,
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
          Text(
            _name ?? '',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    });

    return Container(
      child: Column(
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: this.transaction.products.length,
            itemBuilder: (ctx, index) {
              final item = this.transaction.products[index];
              final product = Provider.of<Products>(context, listen: false)
                  .findById(item.id);

              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      product?.gallery?.first.url ?? '',
                      width: 40.0.h,
                      height: 40.0.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Text('No Image'),
                    ),
                    Text(
                      item.name!,
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
                      'P ${item.quantity! * item.price!}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10.0.h),
          Divider(
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
                    color: kOrangeColor, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
