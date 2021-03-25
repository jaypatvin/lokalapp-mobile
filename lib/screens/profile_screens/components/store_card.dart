import 'package:flutter/material.dart';
import 'package:lokalapp/screens/profile_screens/components/product_card.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class StoreCard extends StatelessWidget {
  final int crossAxisCount;

  StoreCard({
    this.crossAxisCount,
  });
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var products = user.userProducts;
    var shop = user.userShops[0];
    return GridView.builder(
      shrinkWrap: true,
      // primary: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 16.2 / 25.5,
        crossAxisCount: this.crossAxisCount,
      ),
      itemBuilder: (BuildContext context, int index) {
        var gallery = products[index].gallery;
        var isGalleryEmpty = gallery == null || gallery.isEmpty;
        var productImage =
            !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;

        return ProductCard(
          name: products[index].name,
          imageUrl: gallery[0]?.url ?? '',
          price: products[index].basePrice,
          shopName: shop.name,
          shopImageUrl: shop.profilePhoto,
        );
      },
    );
  }
}
