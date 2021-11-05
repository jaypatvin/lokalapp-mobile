import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../routers/app_router.dart';
import '../../../chat/components/chat_avatar.dart';
import '../../add_shop/edit_shop.dart';
import '../../settings/settings.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({
    Key? key,
    required this.shopName,
    this.linearGradientColors = const [Color(0xffFFC700), Colors.black45],
    this.shopProfilePhoto,
    this.shopCoverPhoto,
    this.onSettingsTap,
    this.onEditTap,
    this.displaySettingsButton = true,
    this.displayEditButton = true,
  }) : super(key: key);

  final String shopName;
  final List<Color> linearGradientColors;
  final String? shopProfilePhoto;
  final String? shopCoverPhoto;
  final void Function()? onSettingsTap;
  final void Function()? onEditTap;
  final bool displaySettingsButton;
  final bool displayEditButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image(
            image: NetworkImage(
              shopCoverPhoto!,
            ),
            fit: BoxFit.cover,
            errorBuilder: (ctx, obj, trace) => SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: this.linearGradientColors,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.30),
              ),
            ),
          ),
        ),
        if (this.displaySettingsButton)
          Positioned(
            left: 10.0.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings,
                size: 30.0.r,
              ),
              color: Colors.white,
              onPressed: () {
                context.read<AppRouter>().navigateTo(
                      AppRoute.profile,
                      Settings.routeName,
                    );
              },
            ),
          ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 10.0.h,
              bottom: 10.0.h,
            ),
            child: Column(
              children: [
                ChatAvatar(
                  displayName: shopName,
                  displayPhoto: shopProfilePhoto,
                  radius: 40.0.r,
                ),
                Text(
                  shopName,
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (this.displayEditButton)
          Positioned(
            right: 10.0.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                MdiIcons.squareEditOutline,
                size: 30.0.r,
              ),
              color: Colors.white,
              onPressed: () {
                pushNewScreenWithRouteSettings(
                  context,
                  screen: EditShop(),
                  settings: RouteSettings(name: EditShop.routeName),
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ),
      ],
    );
  }
}
