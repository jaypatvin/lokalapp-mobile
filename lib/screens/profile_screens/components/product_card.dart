import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../utils/themes.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String name;
  final double price;
  final String shopImageUrl;
  final String shopName;
  final double height;
  final double width;

  const ProductCard({
    @required this.productId,
    @required this.imageUrl,
    @required this.name,
    @required this.price,
    @required this.shopImageUrl,
    @required this.shopName,
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.white,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Consumer<ShoppingCart>(
        builder: (context, cart, child) {
          return Container(
            height: this.height,
            width: this.width,
            decoration: BoxDecoration(
              border: cart.contains(productId)
                  ? Border.all(color: Colors.orange, width: 3)
                  : Border.all(color: Colors.transparent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: this.height * 0.55,
                  width: this.width,
                  decoration: BoxDecoration(
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 10.0.h),
                Text(
                  name,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Text(
                  '$price',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: kOrangeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0.sp,
                  ),
                ),
                SizedBox(height: 2.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: 9.0.r,
                        backgroundImage:
                            shopImageUrl != null && shopImageUrl.isNotEmpty
                                ? NetworkImage(shopImageUrl)
                                : null,
                      ),
                    ),
                    SizedBox(width: 5.0.w),
                    Expanded(
                      child: Text(
                        shopName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0.w),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 9.0.r,
                          ),
                        ),
                        Text(
                          "4.54",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 12.0.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
