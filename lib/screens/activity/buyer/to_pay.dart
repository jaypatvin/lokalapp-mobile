import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';

import 'package:lokalapp/screens/activity/components/for_delivery_card.dart';
import 'package:lokalapp/screens/activity/components/order_screen_card.dart';
import 'package:lokalapp/screens/activity/buyer/payment_option.dart';

import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class ToPay extends StatelessWidget {
  TextEditingController _notesController = TextEditingController();

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
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text("Order Confirmed!",
                      style: TextStyle(
                          color: Color(0xFFFFC700),
                          fontSize: 16,
                          fontFamily: "Goldplay",
                          fontWeight: FontWeight.w600))
                ],
              ),
            ),
          ),
        ),
      );

  showCamcelDialog(context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Column(
              children: [
                Text('Are you sure you want to'),
                Text(' decline this order?')
              ],
            ),
          ),
          content: Container(
            height: 140,
            child: Column(
              children: [
                Text(
                  'We will notify the buyer if you decline',
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Text(
                  'this order. Do you want to',
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Text(
                  'message them first?',
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: kTealColor),
                        ),
                        textColor: Colors.black,
                        child: Text(
                          "Keep Order",
                          style: TextStyle(
                              fontFamily: "Goldplay",
                              color: kTealColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.3,
                      // padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FlatButton(
                        color: Color(0XFFCC3752),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Color(0XFFCC3752)),
                        ),
                        textColor: Colors.black,
                        child: Text(
                          "Decline Order",
                          style: TextStyle(
                              fontFamily: "Goldplay",
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<CurrentUser>(context, listen: false);

    var shops =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;

    var products =
        Provider.of<Products>(context, listen: false).findByUser(user.id).first;
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
                showNotes: true,
                leftButtonOnPressed: () {
                  showCamcelDialog(context);
                },
                button: Container(),
                showCancelButton: true,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentOption()));
                },
                buttonLeftText: "Cancel Order",
                confirmation: "Paid, Processing Payment",
                waitingForSeller: "",
                buttonMessage: "Pay Now",
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
