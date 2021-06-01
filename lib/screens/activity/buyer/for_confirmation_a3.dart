import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/components/order_screen_card.dart';
import 'package:lokalapp/screens/activity/buyer/payment_option.dart';
import 'package:lokalapp/screens/chat/chat_view.dart';

import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class ForConfirmation extends StatelessWidget {
  final TextEditingController _notesController = TextEditingController();

  appBar(context) => PreferredSize(
        preferredSize: Size(double.infinity, 95),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 210,
          child: Container(
            decoration: BoxDecoration(color: kTealColor),
            child: Container(
              margin: const EdgeInsets.only(top: 48, left: 10),
              // margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Order Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Goldplay",
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Waiting for confirmation",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Goldplay",
                          fontWeight: FontWeight.w600))
                ],
              ),
            ),
          ),
        ),
      );

  button(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: 40,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: Colors.black,
              child: Text(
                "View Proof of Payment",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    color: kTealColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.8,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: Colors.black,
              child: Text(
                "Message Shop",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    color: kTealColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                var user = Provider.of<CurrentUser>(context, listen: false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatView(
                              shopId: Provider.of<Shops>(context, listen: false)
                                  .findByUser(user.id)
                                  .first,
                              buyerId: user.id,
                              communityId: user.communityId,
                            )));
              },
            ),
          ),
        ],
      );
  var shops;
  var products;
  findByIdShop(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shopUser =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first ??
            print("store null");
    var product = Provider.of<Products>(context, listen: false)
            .findByUser(user.id)
            .first ??
        print("product null");
    // if (shopUser  && product != null) {
    // shops = shopUser;
    // products = product.toMap();
    // } else {
    // print("shop and product null");
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<CurrentUser>(context, listen: false);
    findByIdShop(context);

    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            OrderScreenCard(
                username: shops.name,
                width: size.width * 0.9,
                price: products.basePrice,
                productName: products.name,
                button: button(context),
                showCancelButton: false,
                showButton: false,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentOption()));
                },
                buttonLeftText: "Cancel Order",
                confirmation: "Paid, Processing Payment",
                waitingForSeller: "",
                showNotes: true,
                buttonMessage: "View",
                controller: _notesController),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
