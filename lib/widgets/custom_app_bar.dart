import 'package:flutter/material.dart';

import '../utils/constants/themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  final String titleText;
  final Widget? title;
  final Widget? leading;
  final bool buildLeading;
  final bool centerTitle;
  final Color backgroundColor;
  final Color leadingColor;
  final double elevation;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry titlePadding;
  final PreferredSizeWidget? bottom;
  final TextStyle? titleStyle;
  final void Function()? onPressedLeading;
  final List<Widget>? actions;
  final double leadingWidth;

  const CustomAppBar({
    this.height = kToolbarHeight,
    this.titleText = '',
    this.title,
    this.leading,
    this.buildLeading = true,
    this.centerTitle = true,
    this.backgroundColor = kPurpleColor,
    this.leadingColor = Colors.white,
    this.elevation = 0.0,
    this.leadingPadding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.leadingWidth = 56.0,
    this.bottom,
    this.titleStyle,
    this.onPressedLeading,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: !buildLeading
          ? null
          : leading ?? _Leading(leadingPadding, leadingColor, onPressedLeading),
      leadingWidth: leadingWidth,
      title: title ??
          Padding(
            padding: titlePadding,
            child: _Title(titleText, titleStyle),
          ),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      bottom: bottom,
      titleSpacing: 0,
    );
  }
}

class _Leading extends StatelessWidget {
  final EdgeInsetsGeometry leadingPadding;
  final Color leadingColor;
  final void Function()? onPressedLeading;
  const _Leading(
    this.leadingPadding,
    this.leadingColor,
    this.onPressedLeading, {
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: leadingPadding,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_sharp,
          color: leadingColor,
        ),
        onPressed: onPressedLeading ?? Navigator.of(context).pop,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String titleText;
  final TextStyle? titleStyle;
  const _Title(
    this.titleText,
    this.titleStyle, {
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: const TextStyle(
        fontSize: 20,
        color: Color(0xFFFFC700),
        fontFamily: 'Goldplay',
        fontWeight: FontWeight.w600,
      ).merge(titleStyle),
    );
  }
}
