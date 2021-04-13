import 'package:flutter/material.dart';

class CartActionDetector extends StatefulWidget {
  final Function onSwipeDown;
  final Function onSwipeUp;
  final Function onDoubleTap;
  final Function onTap;
  final Widget child;
  CartActionDetector({
    this.onSwipeUp,
    this.onSwipeDown,
    this.onTap,
    this.onDoubleTap,
    this.child,
  });
  @override
  _CartActionDetectorState createState() => _CartActionDetectorState();
}

class _CartActionDetectorState extends State<CartActionDetector> {
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDrageDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      onDoubleTap: () => widget.onDoubleTap(),
      onVerticalDragStart: (drageDetails) {
        startVerticalDragDetails = drageDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDrageDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDrageDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDrageDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;

        if (velocity < 0) {
          widget.onSwipeUp();
        } else {
          widget.onSwipeDown();
        }
      },
      child: widget.child,
    );
  }
}
