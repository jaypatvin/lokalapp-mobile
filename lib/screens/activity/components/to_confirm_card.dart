import 'package:flutter/material.dart';

class ToConfirmCard extends StatelessWidget {
  final double width;
  final String username;
  final double price;
  final String productName;
  final String imageUrl;
  final ImageProvider backgroundImage;
  ToConfirmCard(
      {this.width,
      this.backgroundImage,
      this.username,
      this.imageUrl,
      this.price,
      this.productName});

  Widget get shopName => Row(
        children: [
          Container(
            child: CircleAvatar(
              radius: 12,
              backgroundImage: backgroundImage,
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

  Widget get toConfirm => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "To Confirm",
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

  Widget get middleSection => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 80.00,
            height: 70.00,
            decoration: BoxDecoration(
              image: this.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl.toString()),
                      fit: BoxFit.cover)
                  : null,
            ),
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

  Widget get activityConfirmCard => Column(children: [
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
    return activityConfirmCard;
  }
}
