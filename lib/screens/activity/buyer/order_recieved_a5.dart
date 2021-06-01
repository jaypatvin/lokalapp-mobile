import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/activity.dart';
import 'package:lokalapp/screens/chat/chat_view.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import '../components/order_screen_card.dart';

class OrderRecieved extends StatelessWidget {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: Colors.black,
              child: Text(
                "Message Shop",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 14,
                    color: kTealColor,
                    // color: Color(0XFFCC3752),
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
                  "Rate your Experience",
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {}),
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
              "Order Received",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "GoldplayBold",
                  fontWeight: FontWeight.w700,
                  fontSize: 24),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 140.0,
              width: 180.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn2.iconfinder.com%2Fdata%2Ficons%2Fshopping-colored-part-2%2F160%2F97-512.png&f=1&nofb=1'),
                  fit: BoxFit.fill,
                ),
              ),
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
