import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/components/order_screen_card.dart';
import 'package:lokalapp/screens/activity/view_proof_of_payment_seller.dart';

import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class SellerConfirmation extends StatelessWidget {
  final TextEditingController _notesController = TextEditingController();
  button(context) => Row(
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
              // height: 50,
              // minWidth: 100,
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
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewProofOfPaymentSeller()));
              },
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = CurrentUser().idToken;
    var shops = Shops().findByUser(user);
    var products = Products().findByShop(user);
    var gallery = products[0].gallery;

    var isGalleryEmpty = gallery == null || gallery.isEmpty;
    var productImage =
        !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Color(0XFF57183F),
        bottom: PreferredSize(
            child: Container(
              color: Color(0XFFCC3752),
              height: 60.0,
              child: Row(
                children: [
                  // SizedBox(
                  //   width: 26,
                  // ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
            preferredSize: Size.fromHeight(60.0)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            OrderScreenCard(
              buttonMessage: "",
              button: button(context),
              confirmation: "Confirmed, To Pay",
              onPressed: () {},
              buttonLeftText: "Cancel Order",
              waitingForSeller: "",
              showButton: false,
              username: shops[0].name,
              imageUrl: isGalleryEmpty ? '' : productImage.url,
              width: size.width * 0.9,
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
