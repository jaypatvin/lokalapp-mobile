import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/components/order_screen_card.dart';
import 'package:lokalapp/screens/activity/seller/seller_confirmation.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class MyShop extends StatelessWidget {
  final TextEditingController _notesController = TextEditingController();

  Widget get button => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: 43,
            width: 160,
            padding: const EdgeInsets.all(2),
            child: FlatButton(
              color: kTealColor,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      );
  appbar(context) => PreferredSize(
      child: Container(
        color: Color(0XFFCC3752),
        height: 60.0,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(context);
                }),
            SizedBox(
              width: 120,
            ),
            Row(
              children: [
                Text(
                  "Order",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "GoldplayBold",
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(60.0));
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<CurrentUser>(context, listen: false);

    var shops =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;

    var products =
        Provider.of<Products>(context, listen: false).findByUser(user.id).first;

    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          backgroundColor: Color(0XFF57183F),
          bottom: appbar(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              OrderScreenCard(
                button: button,
                buttonMessage: "Confirm Order",
                confirmation: "To Confirm",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerConfirmation()));
                },
                buttonLeftText: "Cancel Order",
                controller: _notesController,
                width: size.width * 0.9,
                waitingForSeller: "",
                username: shops.name,
                price: products.basePrice,
                productName: products.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
