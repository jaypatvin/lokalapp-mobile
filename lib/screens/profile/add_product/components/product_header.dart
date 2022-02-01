
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/photo_box.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    required this.productName,
    required this.productPrice,
    required this.productHeaderImageSource,
    this.productStock = 0,
  });
  final String productName;
  final double productPrice;
  final int productStock;
  final PhotoBoxImageSource productHeaderImageSource;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (productHeaderImageSource.isNotEmpty)
          PhotoBox(
            imageSource: productHeaderImageSource,
            shape: BoxShape.rectangle,
            height: 75,
            width: 75,
          )
        else
          Container(
            height: 75.0,
            width: 75.0,
            color: Colors.grey,
            child: const Center(
              child: Text('No Image'),
            ),
          ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PHP ${NumberFormat("#,##0.00").format(productPrice)}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    'In Stock: $productStock',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
