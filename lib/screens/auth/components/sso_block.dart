import 'package:flutter/material.dart';

import '../../../utils/constants/assets.dart';

class SocialBlock extends StatelessWidget {
  final VoidCallback fbLoginCallback;
  final VoidCallback appleLoginCallback;
  final VoidCallback googleLoginCallback;
  final double buttonWidth;

  const SocialBlock({
    required this.fbLoginCallback,
    required this.appleLoginCallback,
    required this.googleLoginCallback,
    this.buttonWidth = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: buttonWidth * 0.5),
      child: Column(
        children: [
          Text(
            'Sign in with',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                image: const AssetImage(kPngFbLogo),
                onTap: fbLoginCallback,
                width: buttonWidth,
              ),
              const SizedBox(width: 9),
              _SocialButton(
                image: const AssetImage(kPngAppleLogo),
                onTap: appleLoginCallback,
                width: buttonWidth,
              ),
              const SizedBox(width: 9),
              _SocialButton(
                image: const AssetImage(kPngGoogleLogo),
                onTap: googleLoginCallback,
                width: buttonWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback onTap;
  final double width;

  const _SocialButton({
    required this.image,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      clipBehavior: Clip.hardEdge,
      color: Colors.grey.shade200,
      child: Ink.image(
        image: image,
        fit: BoxFit.fill,
        height: width,
        width: width,
        child: InkWell(onTap: onTap),
      ),
    );
  }
}
