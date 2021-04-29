import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';

import 'package:lokalapp/screens/activity/components/order_screen_card.dart';

import 'package:lokalapp/utils/themes.dart';

import 'package:provider/provider.dart';

class OrderDetails extends StatelessWidget {
  final TextEditingController _notesController = TextEditingController();

  Widget get placeholder => Container();
  appBar(context) => PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Container(
            decoration: BoxDecoration(color: kTealColor),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.s,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // padding: const EdgeInsets.only(top: 8),
                        child: IconButton(
                            icon: Icon(Icons.arrow_back_outlined),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 80),
                        child: Text(
                          "Order Details",
                          style: TextStyle(
                              fontFamily: "Goldplay",
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7, left: 80),
                        child: Text(
                          "Waiting for confirmation",
                          style: TextStyle(
                              fontFamily: "Goldplay",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            OrderScreenCard(
              button: placeholder,
              onPressed: () {},
              buttonLeftText: "Cancel Order",
              buttonMessage: "Message Shop",
              controller: _notesController,
              username: shops.name,
              width: size.width * 0.9,
              price: products.basePrice,
              productName: products.name,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
