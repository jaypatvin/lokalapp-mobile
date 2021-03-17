import 'package:flutter/material.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class StoreCard extends StatelessWidget {
  final int crossAxisCount;
  StoreCard({this.crossAxisCount});
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
                        height: 180,
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
                      height: 25,
                    ),
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // margin: const EdgeInsets.only(right: 30),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: shop.profilePhoto != null &&
                                      shop.profilePhoto.isNotEmpty
                                  ? NetworkImage(shop.profilePhoto)
                                  : null,
                            ),
                          ),
                          SizedBox(
                            width: 1,
                          ),
                          Container(
                            // margin: const EdgeInsets.only(right: 12),
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
                            width: 60,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                              ),
                              Text("4.54",
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 14)),
                            ],
                          )
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
