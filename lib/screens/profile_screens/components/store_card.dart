import 'package:flutter/material.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class StoreCard extends StatelessWidget {
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
        childAspectRatio: 15.0 / 25.5,
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        var gallery = products[index].gallery;
        var isGalleryEmpty = gallery == null || gallery.isEmpty;
        var productImage =
            !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;

        return Padding(
          padding: EdgeInsets.all(1),
          child: Card(
            color: Colors.white,
            semanticContainer: true,
            clipBehavior: Clip.antiAlias,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        height: 190,
                        width: 260,
                        decoration: BoxDecoration(
                          image: !isGalleryEmpty
                              ? DecorationImage(
                                  image: NetworkImage(productImage.url),
                                  fit: BoxFit.fitWidth)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Text(products[index].name,
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: "GoldplayBold",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '₱ ${products[index].basePrice.toString()}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xffFF7A00),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: shop.profilePhoto != null &&
                                      shop.profilePhoto.isNotEmpty
                                  ? NetworkImage(shop.profilePhoto)
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: Text(
                              shop.name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          Text("4.54",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 14)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
