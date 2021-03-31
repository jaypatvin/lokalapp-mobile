import 'package:flutter/material.dart';

import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
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
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isTapped = false;

  void addToCart(context) {
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    int index;
    var products = _user.userProducts;
    List cart = [];
    if (isTapped == true) {
      cart.add(products[index].id);
      if (cart.contains(products[index].id)) {
        setState(() {
          isTapped = !isTapped;
        });
      }
    }
  }

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
                  child: GestureDetector(
                    onTap: () => addToCart(context),
                    child: Container(
                      height: 180,
                      width: 260,
                      decoration: BoxDecoration(
                        image: widget.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(widget.imageUrl),
                                fit: BoxFit.fitWidth)
                            : null,
                        border: isTapped
                            ? Border.all(
                                color: Colors.orange,
                                width: 3,
                              )
                            : Border.all(color: Colors.transparent),
                      ),
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
                        widget.name,
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
                      '${widget.price}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color(0xffFF7A00),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                SizedBox(
                  height: 19,
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
                          radius: 9,
                          backgroundImage: widget.shopImageUrl != null &&
                                  widget.shopImageUrl.isNotEmpty
                              ? NetworkImage(widget.shopImageUrl)
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                        // margin: const EdgeInsets.only(right: 12),
                        child: Text(
                          widget.shopName,
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
