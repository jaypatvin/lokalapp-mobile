import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../profile_screens/components/product_card.dart';
import '../product_detail.dart';

class RecommendedProducts extends StatelessWidget {
  const RecommendedProducts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<Products, Shops>(
      builder: (context, products, shops, __) {
        return products.isLoading || shops.isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: 250.0.h,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: products.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 2,
                    crossAxisCount: 1,
                  ),
                  itemBuilder: (ctx, index) {
                    final shop = shops.findById(products.items[index].shopId);
                    final gallery = products.items[index].gallery;
                    final isGalleryEmpty = gallery == null || gallery.isEmpty;
                    final productImage = !isGalleryEmpty
                        ? gallery.firstWhere((g) => g.url.isNotEmpty)
                        : null;
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                products.items[index],
                              ),
                            ),
                          );
                        },
                        child: ProductCard(
                          productId: products.items[index].id,
                          name: products.items[index].name,
                          imageUrl: isGalleryEmpty ? '' : productImage.url,
                          price: products.items[index].basePrice,
                          shopName: shop.name,
                          shopImageUrl: shop.profilePhoto,
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
