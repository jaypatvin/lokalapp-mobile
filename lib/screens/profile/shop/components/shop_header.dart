import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    this.onOptionsTap,
    this.onShopPhotoTap,
    this.onEditTap,
    // this.displaySettingsButton = true,
    // this.displayEditButton = true,
  }) : super(key: key);

  final String shopName;
  final List<Color> linearGradientColors;
  final String? shopProfilePhoto;
  final String? shopCoverPhoto;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onShopPhotoTap;
  // final bool displaySettingsButton;
  // final bool displayEditButton;

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
        if (onSettingsTap != null)
          Positioned(
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.settings,
                  size: 25,
                ),
                color: Colors.white,
                onPressed: onSettingsTap,
              ),
            ),
          ),
        Transform.translate(
          offset: const Offset(0, -10.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: ChatAvatar(
                displayName: shopName,
                displayPhoto: shopProfilePhoto,
                radius: 45,
                onTap: onShopPhotoTap,
              ),
            ),
          ),
        ),
        if (onEditTap != null)
          Positioned(
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  MdiIcons.squareEditOutline,
                  size: 25,
                ),
                color: Colors.white,
                onPressed: onEditTap,
              ),
            ),
          )
        else if (onOptionsTap != null)
          Positioned(
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_horiz,
                  size: 25,
                ),
                color: Colors.white,
                onPressed: onOptionsTap,
              ),
            ),
          ),
      ],
    );
  }
}
