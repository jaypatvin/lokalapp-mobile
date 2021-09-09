import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../providers/user.dart';
import '../../discover/product_detail.dart';
import 'product_card.dart';

class StoreCard extends StatelessWidget {
  final int crossAxisCount;
  final bool isUserProducts;

  StoreCard({
    this.crossAxisCount,
    this.isUserProducts = false,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer3<CurrentUser, Shops, Products>(
      builder: (_, user, shops, products, __) {
        var items = isUserProducts
            ? products.findByUser(user.id)
            : products.items
                .where((product) => product.userId != user.id)
                .toList();
        return shops.isLoading || products.isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                // primary: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.4),
                  crossAxisCount: this.crossAxisCount,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var gallery = items[index].gallery;
                  var isGalleryEmpty = gallery == null || gallery.isEmpty;
                  var productImage = !isGalleryEmpty
                      ? gallery.firstWhere((g) => g.url != null)
                      : null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(items[index]),
                        ),
                      );
                    },
                    child: ProductCard(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      productId: items[index].id,
                      name: items[index].name,
                      imageUrl: isGalleryEmpty ? '' : productImage.url,
                      price: items[index].basePrice,
                      shopName: shops.findById(items[index].shopId).name,
                      shopImageUrl:
                          shops.findById(items[index].shopId).profilePhoto,
                    ),
                  );
                },
              );
      },
    );
  }
}
