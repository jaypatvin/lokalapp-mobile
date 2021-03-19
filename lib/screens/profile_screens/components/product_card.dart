import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String shopImageUrl;
  final String shopName;

  const ProductCard({
    @required this.imageUrl,
    @required this.name,
    @required this.price,
    @required this.shopImageUrl,
    @required this.shopName,
  });

  @override
  Widget build(BuildContext context) {
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
                      image: imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(imageUrl),
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
                      child: Text(
                        name,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "GoldplayBold",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '₱ $price',
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
                          backgroundImage:
                              shopImageUrl != null && shopImageUrl.isNotEmpty
                                  ? NetworkImage(shopImageUrl)
                                  : null,
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Container(
                        // margin: const EdgeInsets.only(right: 12),
                        child: Text(
                          shopName,
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
                          Text(
                            "4.54",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 14,
                            ),
                          ),
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
  }
}
