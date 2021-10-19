import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../providers/shops.dart';
import '../../../providers/user.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../add_shop_screens/add_shop.dart';
import '../../chat/components/chat_avatar.dart';
import '../../verification_screens/verify_screen.dart';
import '../user_shop.dart';

class UserShopBanner extends StatefulWidget {
  const UserShopBanner({Key? key}) : super(key: key);

  @override
  _UserShopBannerState createState() => _UserShopBannerState();
}

class _UserShopBannerState extends State<UserShopBanner> {
  Stream<DocumentSnapshot>? _userStream;
  bool _verified = false;

  @override
  void initState() {
    super.initState();

    final user = context.read<CurrentUser>();
    final isVerified = user.registrationStatus!.verified!;

    _verified = isVerified;

    if (!isVerified) {
      _userStream = FirebaseFirestore.instance
          .collection("users")
          .doc(user.id)
          .snapshots();

      _userStream!.listen(_streamListener);
    }
  }

  void _streamListener(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      final snapshotData = snapshot.data() as Map<String, dynamic>;
      final bool validated = snapshotData["registration"]["verified"];
      if (validated) {
        setState(() {
          _verified = true;
        });
        final fireUser = FirebaseAuth.instance.currentUser!;
        context.read<CurrentUser>().fetch(fireUser);
        _userStream = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_verified) {
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
        final user = context.read<CurrentUser>();
        final shops = shopProvider.findByUser(user.id);
        if (shops.isEmpty) {
          return Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.0.w),
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
            padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.0.w),
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
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
  }
}
