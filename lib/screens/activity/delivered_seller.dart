import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:provider/provider.dart';

import 'components/order_screen_card.dart';

class DeliveredSeller extends StatelessWidget {
  final TextEditingController _notesController = TextEditingController();
  Widget get placeholder => Container();
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
    var user = CurrentUser().idToken;
    var shops = Shops().fetch(user);
    var products = Products().findByShop(user);

    var gallery = products[0].gallery;

    var isGalleryEmpty = gallery == null || gallery.isEmpty;
    var productImage =
        !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Color(0XFF57183F),
        bottom: appbar(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            OrderScreenCard(
              button: placeholder,
              showCancelButton: false,
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => PaymentOption()));
              },
              buttonMessage: "Order Delivered",
              showButton: true,
              confirmation: "For Delivery",

              imageUrl: isGalleryEmpty ? '' : productImage.url,
              width: size.width * 0.9,
              waitingForSeller: "",
              // buttonMessage: "Order Received",
              controller: _notesController,
              username: user,

              price: products[0].basePrice,
              productName: products[0].name,
              backgroundImage: products[0].productPhoto != null &&
                      products[0].productPhoto.isNotEmpty
                  ? NetworkImage(products[0].productPhoto)
                  : null,
            )
          ],
        ),
      ),
    );
  }
}