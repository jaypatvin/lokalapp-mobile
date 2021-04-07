import 'package:flutter/material.dart';
import 'package:lokalapp/screens/activity/components/for_delivery_card.dart';
import 'package:lokalapp/screens/activity/components/prep_order_card.dart';
import 'package:lokalapp/screens/activity/components/to_confirm_card.dart';
import 'package:lokalapp/screens/activity/delivered_buyer.dart';
import 'package:lokalapp/screens/activity/for_delivery_buyer.dart';
import 'package:lokalapp/screens/activity/my_shop.dart';
import 'package:lokalapp/screens/activity/order_screen.dart';
import 'package:lokalapp/screens/activity/to_pay.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CurrentUser user = Provider.of(context, listen: false);
    var products = user.userProducts;
    var gallery = products[0].gallery;

    var isGalleryEmpty = gallery == null || gallery.isEmpty;
    var productImage =
        !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTealColor,
        bottom: PreferredSize(
            child: Container(
              color: Color(0XFFCC3752),
              height: 60.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Padding(padding: const EdgeInsets.only(left: 30)),
                  SizedBox(
                    width: 26,
                  ),
                  Text(
                    "My Activity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "GoldplayBold",
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {})
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60.0)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderScreen()));
                      },
                      child: Text(
                        "My Orders",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: isPressed
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyShop()));
                      },
                      child: Text(
                        "My Shop",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: isPressed
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliveredBuyer()));
                      },
                      child: Text(
                        "History",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: isPressed
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderScreen()));
                      },
                      child: Text(
                        "For Confirmation",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: isPressed
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ToPay()));
                      },
                      child: Text(
                        "To Pay",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: isPressed
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForDeliveryBuyer()));
                      },
                      child: Text(
                        "For Delivery",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: isPressed
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ToConfirmCard(
              username: user.userShops[0].name,
              imageUrl: isGalleryEmpty ? '' : productImage.url,
              width: size.width * 0.9,
              price: user.userProducts[0].basePrice,
              productName: user.userProducts[0].name,
              backgroundImage: user.userShops[0].profilePhoto != null &&
                      user.userShops[0].profilePhoto.isNotEmpty
                  ? NetworkImage(user.userShops[0].profilePhoto)
                  : null,
            ),
            SizedBox(
              height: 10,
            ),
            ForDeliveryCard(
              username: user.userShops[0].name,
              imageUrl: isGalleryEmpty ? '' : productImage.url,
              width: size.width * 0.9,
              price: user.userProducts[0].basePrice,
              productName: user.userProducts[0].name,
              backgroundImage: user.userShops[0].profilePhoto != null &&
                      user.userShops[0].profilePhoto.isNotEmpty
                  ? NetworkImage(user.userShops[0].profilePhoto)
                  : null,
            ),
            SizedBox(
              height: 10,
            ),
            PrepOrderCard(
              username: user.userShops[0].name,
              imageUrl: isGalleryEmpty ? '' : productImage.url,
              width: size.width * 0.9,
              price: user.userProducts[1].basePrice,
              productName: user.userProducts[0].name,
              backgroundImage: user.userShops[0].profilePhoto != null &&
                      user.userShops[0].profilePhoto.isNotEmpty
                  ? NetworkImage(user.userShops[0].profilePhoto)
                  : null,
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
