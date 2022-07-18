import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';

class AddProductConfirmation extends StatelessWidget {
  const AddProductConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Product Added!',
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        buildLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Text(
                          'Your new product has now been added to your store!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.filled(
                text: 'Back to my Shop',
                onPressed: () {
                  locator<AppRouter>().popUntil(
                    AppRoute.profile,
                    predicate:
                        ModalRoute.withName(DashboardRoutes.profileScreen),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
