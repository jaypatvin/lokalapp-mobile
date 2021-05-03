import 'package:flutter/material.dart';

import '../../../utils/themes.dart';
import '../../../widgets/photo_box.dart';

class ProductHeader extends StatelessWidget {
  final PhotoBox photoBox;
  final String productName;
  final double productPrice;
  final int productStock;
  ProductHeader({
    @required this.photoBox,
    @required this.productName,
    @required this.productPrice,
    this.productStock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        photoBox.file != null
            ? photoBox
            : Container(
                height: 75.0,
                width: 75.0,
                color: Colors.grey,
                child: Center(
                  child: Text("No Image"),
                ),
              ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.10,
        ),
        // TODO: use Consumer<ProductBody>()
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: kTextStyle.copyWith(
                  fontSize: MediaQuery.of(context).size.width * 0.065,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PHP $productPrice".padRight(10, '0'),
                    style: kTextStyle.copyWith(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Visibility(
                    visible: productStock != null,
                    child: Text(
                      "In Stock: $productStock",
                      style: kTextStyle.copyWith(
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
