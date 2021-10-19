import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/themes.dart';
import '../../../widgets/photo_box.dart';

class ProductHeader extends StatelessWidget {
  final PhotoBox photoBox;
  final String? productName;
  final double? productPrice;
  final int? productStock;
  ProductHeader({
    required this.photoBox,
    required this.productName,
    required this.productPrice,
    this.productStock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        photoBox.file != null || photoBox.url != null
            ? photoBox
            : Container(
                height: 75.0,
                width: 75.0,
                color: Colors.grey,
                child: Center(
                  child: Text("No Image"),
                ),
              ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName!,
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
                  Visibility(
                    visible: productStock != null,
                    child: Text(
                      "In Stock: $productStock",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
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
