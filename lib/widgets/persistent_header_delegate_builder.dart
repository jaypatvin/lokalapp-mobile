import 'package:flutter/material.dart';

class PersistentHeaderDelegateBuilder extends SliverPersistentHeaderDelegate {
  const PersistentHeaderDelegateBuilder({
    required this.child,
    this.maxHeight = 75.0,
    this.minHeight = 75.0,
  });
  final Widget child;
  final double maxHeight;
  final double minHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
