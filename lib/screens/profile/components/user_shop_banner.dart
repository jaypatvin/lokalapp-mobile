import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/verification/verify_screen.dart';
import '../../chat/components/chat_avatar.dart';
import '../add_shop/add_shop.dart';
import '../user_shop.dart';

class UserShopBanner extends StatelessWidget {
  const UserShopBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, child) {
        final registration = auth.user?.registration;

        if (registration == null ||
            registration.verified == null ||
            !registration.verified!) {
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                tileColor: kPinkColor,
                title: Text(
                  "Verify Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 14.0.r,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyScreen(
                      skippable: false,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 75.0.w),
                color: Colors.transparent,
                child: Text(
                  "You must verify your account to add a shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPinkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }

        return Consumer<Shops>(
          builder: (ctx, shopProvider, child) {
            final user = context.read<Auth>().user!;
            final shops = shopProvider.findByUser(user.id);
            if (shops.isEmpty) {
              return Container(
                color: Colors.white,
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.0.w),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 100.0.w,
                    child: AppButton(
                      "+ ADD SHOP",
                      kTealColor,
                      false,
                      () {
                        pushNewScreen(
                          context,
                          screen: AddShop(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              final shop = shops.first;
              return Container(
                padding:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.0.w),
                color: Colors.white,
                child: ListTile(
                  leading: ChatAvatar(
                    displayName: shop.name,
                    displayPhoto: shop.profilePhoto,
                  ),
                  onTap: () {
                    pushNewScreenWithRouteSettings(
                      context,
                      screen: UserShop(),
                      settings: RouteSettings(name: UserShop.routeName),
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  title: Text(
                    shop.name!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0.sp,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "0",
                        style: TextStyle(color: Colors.amber, fontSize: 14),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: kTealColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
