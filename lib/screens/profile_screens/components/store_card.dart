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
        childAspectRatio: 15.0 / 26.5,
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(1),
          child: Card(
            color: Colors.white,
            semanticContainer: true,
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200.5,
                        width: 250,
                        decoration: BoxDecoration(
                          image: products[index].gallery?.url != null &&
                                  products[index].gallery.url.isNotEmpty
                              ? DecorationImage(
                                  image:
                                      NetworkImage(products[index].gallery.url),
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
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: shop.profilePhoto != null &&
                                  shop.profilePhoto.isNotEmpty
                              ? NetworkImage(shop.profilePhoto)
                              : null,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          shop.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              // fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 45,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text("4.54",
                                style: TextStyle(
                                    color: Colors.amber, fontSize: 14)),
                          ],
                        )
                      ],
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
