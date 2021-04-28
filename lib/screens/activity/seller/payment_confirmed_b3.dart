import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/activity.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import '../components/order_screen_card.dart';

class PaymentConfirmedSeller extends StatelessWidget {
  final TextEditingController _notesController = TextEditingController();
  buildButtons(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 25),
            height: 43,
            width: MediaQuery.of(context).size.width * 0.9,
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
                    fontSize: 14,
                    color: kTealColor,
                    // color: Color(0XFFCC3752),
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 43,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.only(left: 10, right: 25),
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
                  "Back to Activity",
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Activity()),
                      (route) => false);
                }),
          ),
          SizedBox(
            width: 5,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Text(
              "Payment Confirmed!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "GoldplayBold",
                  fontWeight: FontWeight.w700,
                  fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 140.0,
              width: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.shareicon.net%2Fdata%2F512x512%2F2016%2F04%2F23%2F754062_arrows_512x512.png&f=1&nofb=1'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            OrderScreenCard(
              button: buildButtons(context),
              showCancelButton: false,
              onPressed: () {},
              confirmation: "Paid, Processing Payment",
              waitingForSeller: "",
              buttonMessage: "Message Seller",
              showNotes: false,
              showButton: false,
              controller: _notesController,
              username: shops.name,
              width: size.width * 0.9,
              price: products.basePrice,
              productName: products.name,
            )
          ],
        ),
      ),
    );
  }
}
