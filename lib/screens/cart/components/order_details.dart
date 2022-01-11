import 'package:flutter/material.dart';

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
        Expanded(
          child: Row(
            children: [
              if (product.gallery != null && product.gallery!.isNotEmpty)
                SizedBox(
                  width: 60.0,
                  height: 60.0,
                  child: Image(
                    image: NetworkImage(product.gallery!.first.url),
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, obj, stk) => const SizedBox(),
                  ),
                ),
              if (product.gallery == null || product.gallery!.isEmpty)
                SizedBox(
                  width: 60.0,
                  height: 60.0,
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
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Goldplay',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: onEditTap,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16.0,
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
        const SizedBox(width: 8.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'x$quantity',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'GoldplayBold',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              product.basePrice.toString(),
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: 'GoldplayBold',
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
