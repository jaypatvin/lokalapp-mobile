import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../profile_screens/user_shop.dart';

class AddProductConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Product Added!",
        backgroundColor: Colors.white,
        elevation: 0,
        titleStyle: TextStyle(color: Colors.black),
        buildLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                  Lottie.asset(kAnimationProductAdded, fit: BoxFit.contain),
                  SvgPicture.asset(
                    kSvgBackgroundHouses,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Your new product has now been added to your store!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Go to Listing",
                kTealColor,
                false,
                () {
                  // TODO: what to do from here
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Back to my Shop",
                kTealColor,
                true,
                () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(UserShop.routeName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
