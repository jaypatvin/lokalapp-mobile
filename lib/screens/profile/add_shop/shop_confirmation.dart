import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lokalapp/providers/auth.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../profile/profile_screen.dart';
import '../shop/user_shop.dart';
import '../add_product/add_product.dart';

class AddShopConfirmation extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        width: width,
        height: height * 0.8,
        child: Column(
          children: [
            Spacer(),
            Container(
              height: height * 0.3,
              constraints: BoxConstraints(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(
                    kAnimationShopOpen,
                    fit: BoxFit.contain,
                  ),
                  SvgPicture.asset(
                    kSvgBackgroundHouses,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            Text(
              "Your Shop is now open for business!\n"
              "Get ready to add products to your shop.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "+ Add a New Product",
                kTealColor,
                false,
                () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(ProfileScreen.routeName),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddProduct(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Back to My Shop",
                kTealColor,
                true,
                () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(ProfileScreen.routeName),
                  );

                  final user = context.read<Auth>().user!;
                  pushNewScreenWithRouteSettings(
                    context,
                    screen: UserShop(userId: user.id!),
                    settings: RouteSettings(name: UserShop.routeName),
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
