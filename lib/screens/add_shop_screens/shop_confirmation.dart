import 'package:flutter/material.dart';

import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import '../add_product_screen/add_product.dart';

class AddShopConfirmation extends StatelessWidget {
  Widget listingButton(BuildContext context) {
    return FlatButton(
      minWidth: double.infinity,
      height: MediaQuery.of(context).size.height * 0.058,
      child: Text(
        "+ Add a New Product",
        style: TextStyle(
          color: Color(0XFF09A49A),
          fontFamily: "Goldplay",
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: kTealColor,
        ),
      ),
      onPressed: () {
        // TODO: where to go from here
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 4);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AddProduct(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Shop Added!",
        backgroundColor: Colors.white,
        elevation: 0,
        titleStyle: TextStyle(color: Colors.black),
        buildLeading: false,
      ),
      body: Container(
        width: width,
        height: height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: height * 0.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/product_added.png"),
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: AssetImage("assets/product_added_2.png"),
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Your Shop is now open for business!\nGet ready to add products to your shop.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: height * 0.023,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            listingButton(context),
            SizedBox(height: height * 0.02),
            RoundedButton(
              label: "Back to My Shop",
              height: 10,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "GoldplayBold",
              fontColor: Colors.white,
              onPressed: () {
                // TODO: define route names for easier navigation
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 4);
              },
            ),
          ],
        ),
      ),
    );
  }
}
