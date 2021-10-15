import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../providers/shops.dart';
import '../../../providers/user.dart';
import '../../add_shop_screens/edit_shop.dart';
import '../../chat/components/chat_avatar.dart';
import '../settings/settings.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    final shop = context.read<Shops>().findByUser(user.id).first;
    return Stack(
      children: [
        Positioned.fill(
          child: const SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffFFC700), Colors.black45],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Image(
            image: NetworkImage(
              shop.coverPhoto!,
            ),
            fit: BoxFit.cover,
            errorBuilder: (ctx, obj, trace) => const SizedBox(),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.settings,
                  size: 30.0.r,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0.h),
                child: Column(
                  children: [
                    ChatAvatar(
                      displayName: shop.name,
                      displayPhoto: shop.profilePhoto,
                      radius: 40.0.r,
                    ),
                    Text(
                      shop.name!,
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
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
            ],
          ),
        ),
      ],
    );
  }
}
