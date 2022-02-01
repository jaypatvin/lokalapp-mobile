import 'package:flutter/material.dart';

class ConstrainedScrollView extends StatelessWidget {
  /// Makes it possible to use [Expanded] or
  /// [Spacer] for devices that allow the it. Disregards [Expanded] or
  /// [Spacer] if the [ViewPort] is smaller than the height of the child.
  const ConstrainedScrollView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: child,
            ),
          ),
        );
      },
    );
  }
}
