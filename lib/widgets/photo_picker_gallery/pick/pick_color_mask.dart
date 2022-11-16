import 'package:flutter/material.dart';

typedef PickColorMaskBuilder = Widget Function(
  BuildContext context, {
  required bool picked,
});

class PickColorMask extends StatelessWidget {
  final Color maskColor;
  final bool picked;
  const PickColorMask({
    super.key,
    this.maskColor = const Color(0x99000000),
    required this.picked,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        width: double.infinity,
        height: double.infinity,
        color: picked ? maskColor : Colors.transparent,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  static PickColorMask buildWidget(
    BuildContext context, {
    required bool picked,
  }) {
    return PickColorMask(
      picked: picked,
    );
  }
}
