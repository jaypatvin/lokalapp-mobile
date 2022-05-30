import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/props/user_shop.props.dart';
import '../../../utils/constants/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../profile/profile_screen.dart';
import '../add_product/add_product.dart';
import '../shop/user_shop.dart';

class AddShopConfirmation extends StatelessWidget {
  static const routeName = '/profile/addShop/confirmation';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Shop Added!',
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        buildLeading: false,
      ),
      body: ConstrainedScrollView(
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              height: 180,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your Shop is now open for business!\n'
                'Get ready to add products to your shop.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.black),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.transparent(
                  text: '+ Add a New Product',
                  onPressed: () {
                    final user = context.read<Auth>().user!;
                    AppRouter.profileNavigatorKey.currentState
                      ?..popUntil(ModalRoute.withName(ProfileScreen.routeName))
                      ..pushNamed(
                        UserShop.routeName,
                        arguments: UserShopProps(user.id),
                      )
                      ..pushNamed(AddProduct.routeName);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  text: 'Back to My Shop',
                  onPressed: () {
                    final user = context.read<Auth>().user!;
                    AppRouter.profileNavigatorKey.currentState
                      ?..popUntil(ModalRoute.withName(ProfileScreen.routeName))
                      ..pushNamed(
                        UserShop.routeName,
                        arguments: UserShopProps(user.id),
                      );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
