import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../chat/components/chat_avatar.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({
    Key? key,
    required this.shopName,
    this.linearGradientColors = const [Color(0xffFFC700), Colors.black45],
    this.shopProfilePhoto,
    this.shopCoverPhoto,
    this.onSettingsTap,
    this.onEditTap,
    this.onShopPhotoTap,
    this.displaySettingsButton = true,
    this.displayEditButton = true,
  }) : super(key: key);

  final String shopName;
  final List<Color> linearGradientColors;
  final String? shopProfilePhoto;
  final String? shopCoverPhoto;
  final void Function()? onSettingsTap;
  final void Function()? onEditTap;
  final void Function()? onShopPhotoTap;
  final bool displaySettingsButton;
  final bool displayEditButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: shopCoverPhoto ?? '',
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            errorWidget: (ctx, url, err) => SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: linearGradientColors,
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
        if (displaySettingsButton)
          Positioned(
            left: 10.0.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings,
                size: 30.0.r,
              ),
              color: Colors.white,
              onPressed: onSettingsTap,
            ),
          ),
        Transform.translate(
          offset: const Offset(0, -10.0),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10.0.h,
                bottom: 10.0.h,
              ),
              child: ChatAvatar(
                displayName: shopName,
                displayPhoto: shopProfilePhoto,
                radius: 40.0.r,
                onTap: onShopPhotoTap,
              ),
            ),
          ),
        ),
        if (displayEditButton)
          Positioned(
            right: 10.0.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                MdiIcons.squareEditOutline,
                size: 30.0.r,
              ),
              color: Colors.white,
              onPressed: onEditTap,
            ),
          ),
      ],
    );
  }
}
