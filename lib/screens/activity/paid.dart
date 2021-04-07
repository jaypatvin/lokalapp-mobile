import 'package:flutter/material.dart';
import 'package:lokalapp/screens/activity/for_delivery_buyer.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import 'components/order_screen_card.dart';

class Paid extends StatelessWidget {
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
    CurrentUser user = Provider.of(context, listen: false);
    var products = user.userProducts;
    var gallery = products[0].gallery;

    var isGalleryEmpty = gallery == null || gallery.isEmpty;
    var productImage =
        !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: kTealColor,
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
              onPressed: () {},
              confirmation: "Paid, Processing Payment",
              username: user.userShops[0].name,
              imageUrl: isGalleryEmpty ? '' : productImage.url,
              width: size.width * 0.9,
              waitingForSeller: "",
              buttonMessage: "Message Seller",
              controller: _notesController,
              price: user.userProducts[0].basePrice,
              productName: user.userProducts[0].name,
              backgroundImage: user.userShops[0].profilePhoto != null &&
                      user.userShops[0].profilePhoto.isNotEmpty
                  ? NetworkImage(user.userShops[0].profilePhoto)
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
