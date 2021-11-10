import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/discover/product_card.vm.dart';
import '../../chat/components/chat_avatar.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.productId);
  final String productId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<ShoppingCart, ProductCardViewModel>(
      create: (ctx) => ProductCardViewModel(ctx, productId)..init(),
      update: (ctx, cart, vm) => vm!
        ..updateDisplayBorder(
          cart.contains(productId),
        ),
      builder: (_, __) {
        return Consumer<ProductCardViewModel>(
          builder: (ctx2, vm, _) {
            return Container(
              decoration: BoxDecoration(
                border: vm.displayBorder
                    ? Border.all(color: Colors.orange, width: 3)
                    : Border.all(color: Colors.transparent),
              ),
              child: GridTile(
                child: Image.network(
                  vm.productImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, _, __) => SizedBox(
                    child: Text("No Image"),
                  ),
                ),
                footer: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0.w,
                    vertical: 2.0.h,
                  ),
                  constraints: BoxConstraints(),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.productName,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vm.productPrice,
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: kOrangeColor),
                          ),
                          GestureDetector(
                            onTap: vm.onLike,
                            child: Icon(
                              MdiIcons.heartOutline,
                              size: 24.0.r,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChatAvatar(
                            displayName: vm.shop.name,
                            displayPhoto: vm.shop.profilePhoto,
                            radius: 9.0.r,
                            onTap: vm.onShopTap,
                          ),
                          SizedBox(width: 5.0.w),
                          Expanded(
                            child: Text(
                              vm.shop.name!,
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
                                vm.productRating,
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12.0.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
