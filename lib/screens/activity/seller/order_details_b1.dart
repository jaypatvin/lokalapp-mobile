import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/components/order_screen_card.dart';
import 'package:lokalapp/screens/activity/buyer/payment_option.dart';
import 'package:lokalapp/screens/activity/seller/order_confimred_b1.dart';
import 'package:lokalapp/utils/themes.dart';

import 'package:provider/provider.dart';

class OrderDetailsSeller extends StatelessWidget {
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
            decoration: BoxDecoration(color: Color(0XFF57183F)),
            child: Container(
              margin: const EdgeInsets.only(top: 60, left: 15),
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
                ],
              ),
            ),
          ),
        ),
      );

  button(context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.8,
                // padding: const EdgeInsets.only(left: 10, right: 30),
                child: FlatButton(
                  // height: 50,
                  // minWidth: 100,
                  // color: kTealColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: kTealColor),
                  ),
                  textColor: Colors.black,
                  child: Text(
                    "Message Buyer",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        color: kTealColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Color(0XFFCC3752)),
                  ),
                  textColor: Colors.black,
                  child: Text(
                    "Decline Order",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        color: Color(0XFFCC3752),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: FlatButton(
                  // height: 50,
                  // minWidth: 100,
                  color: Color(0XFFFF7A00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Color(0XFFFF7A00)),
                  ),
                  textColor: Colors.black,
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderConfirmed()));
                  },
                ),
              ),
            ],
          ),
        ],
      );
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
