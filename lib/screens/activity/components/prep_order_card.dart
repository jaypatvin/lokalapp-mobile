import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:provider/provider.dart';

class PrepOrderCard extends StatelessWidget {
  final double width;
  final String username;
  final double price;
  final String productName;
  final String imageUrl;
  final ImageProvider backgroundImage;
  PrepOrderCard(
      {this.width,
      this.backgroundImage,
      this.username,
      this.imageUrl,
      this.price,
      this.productName});
  Widget get shopName => Consumer<Products>(builder: (context, products, __) {
        return products.isLoading
            ? Container()
            : Container(
                height: 40,
                width: 105,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (ctx, index) {
                      var shop = Provider.of<Shops>(context, listen: false)
                          .findById(products.items[index].shopId);
                      var gallery = shop.profilePhoto;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(gallery),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            username,
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      );
                    }),
              );
      });

  Widget get toConfirm => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Preparing Order",
            style: TextStyle(
                fontFamily: "GoldplayBold",
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
          Text(
            "19 Oct",
            style: TextStyle(
                fontFamily: "GoldplayBold",
                fontSize: 10,
                fontWeight: FontWeight.w400),
          )
        ],
      );

  Widget get middleSection =>
      Consumer<Products>(builder: (context, products, __) {
        return products.isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (ctx, index) {
                      var shop = Provider.of<Shops>(context, listen: false)
                          .findById(products.items[index].shopId);
                      var gallery = products.items[index].gallery;
                      var isGalleryEmpty = gallery == null || gallery.isEmpty;
                      var productImage = !isGalleryEmpty
                          ? gallery.firstWhere((g) => g.url.isNotEmpty)
                          : null;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // width: MediaQuery.of(context).size.width,
                            height: 60.0,
                            width: 80.0,
                            // height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      isGalleryEmpty ? '' : productImage.url,
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(right: 90),
                                  child: Text(
                                    productName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "GoldplayBold",
                                        fontWeight: FontWeight.w700),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: Text(
                                  "December 20",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: "GolplayBold",
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "x1",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                  // padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                "P $price",
                                // textAlign: TextAlign.end,
                                style: TextStyle(fontWeight: FontWeight.w300),
                              )),
                            ],
                          ),
                        ],
                      );
                    }),
              );
      });
  Widget get orderTotal => Container(
          child: Text(
        "Order Total",
        style: TextStyle(
            fontSize: 16, fontFamily: "Goldplay", fontWeight: FontWeight.w300),
      ));

  Widget get totalPrice => Expanded(
        child: Text(
          price.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0XFFFF7A00),
              fontSize: 16),
        ),
      );

  Widget get activityPrepOrderCard => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipPath(
              child: Container(
                height: 210,
                width: width,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(20),
                child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 2,
                            // width: 30,
                          ),
                          toConfirm,
                          SizedBox(
                            height: 20,
                          ),
                          middleSection,
                          SizedBox(
                            height: 9,
                          ),
                          Divider(
                            color: Colors.grey,
                            indent: 0,
                            // endIndent: 25,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              shopName,
                              SizedBox(
                                width: 70,
                              ),
                              orderTotal,
                              SizedBox(
                                width: 10,
                              ),
                              totalPrice
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return activityPrepOrderCard;
  }
}
