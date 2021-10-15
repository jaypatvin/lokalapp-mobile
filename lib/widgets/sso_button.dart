import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final ImageProvider? image;
  final Function? onTap;
  final double? width;

  const SocialButton({this.image, this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      clipBehavior: Clip.hardEdge,
      color: Colors.grey[200],
      child: Ink.image(
        image: image!,
        fit: BoxFit.fill,
        height: this.width,
        width: this.width,
        child: InkWell(
          onTap: this.onTap as void Function()?,
        ),
      ),
    );
  }
}
