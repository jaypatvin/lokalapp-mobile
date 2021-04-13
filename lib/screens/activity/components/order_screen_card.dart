import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';

import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class OrderScreenCard extends StatelessWidget {
  final double width;
  final String username;
  final String buttonLeftText;
  Function onPressed;
  final String confirmation;
  final bool showCancelButton;
  final double price;
  final String buttonMessage;
  final String waitingForSeller;
  final String productName;
  Widget button;
  final bool showButton;
  final String imageUrl;
  final ImageProvider backgroundImage;
  final controller;
  OrderScreenCard(
      {this.width,
      this.backgroundImage,
      this.buttonLeftText,
      this.confirmation,
      this.showCancelButton = true,
      this.waitingForSeller,
      this.username,
      this.onPressed,
      this.showButton = true,
      this.imageUrl,
      this.buttonMessage,
      this.price,
      this.button,
      this.controller,
      this.productName});

  Widget get shopName => Consumer<Products>(builder: (context, products, __) {
        return products.isLoading
            ? Container()
            : Container(
                height: 30,
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
                            height: 30,
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
            "19 Oct",
            style: TextStyle(
                fontFamily: "GoldplayBold",
                fontSize: 10,
                fontWeight: FontWeight.w400),
          ),
          Text(
            confirmation,
            style: TextStyle(
                fontFamily: "GoldplayBold",
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
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

  Widget get totalPrice => Text(
        price.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0XFFFF7A00),
            fontSize: 16),
      );

  Widget get notes => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
              ),
              Text(
                "Notes",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Goldplay"),
              ),
            ],
          ),
          Container(
            child: TextField(
              cursorColor: Colors.grey,
              maxLines: 3,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),
              controller: controller,
            ),
          ),
        ],
      );

  Widget get orderCard => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipPath(
              child: Container(
                height: 250,
                width: width,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(20),
                child: ListView(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 2,
                        // width: 30,
                      ),
                      toConfirm,
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            waitingForSeller,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "GoldplayBold",
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          shopName,
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      middleSection,
                      SizedBox(
                        height: 9,
                      ),
                      Divider(
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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

  Widget get buildButtons => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 5),
          showCancelButton
              ? Container(
                  padding: const EdgeInsets.all(2),
                  height: 43,
                  width: 190,
                  child: FlatButton(
                    // height: 50,
                    // minWidth: 100,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Color(0XFFCC3752)),
                    ),
                    textColor: Colors.black,
                    child: Text(
                      buttonLeftText,
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 13,
                          color: Color(0XFFCC3752),
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {},
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(2),
                  height: 43,
                  width: 190,
                ),
          Container(
            height: 43,
            width: 190,
            padding: const EdgeInsets.all(2),
            child: FlatButton(
              // height: 50,
              // minWidth: 100,
              color: kTealColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: Colors.black,
              child: Text(
                buttonMessage,
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: onPressed,
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        orderCard,
        SizedBox(
          height: 18,
        ),
        notes,
        button,
        SizedBox(height: 130),
        showButton ? buildButtons : Container()
      ],
    );
  }
}
