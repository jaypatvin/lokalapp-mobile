import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedAspectRatio extends ImplicitlyAnimatedWidget {
  AnimatedAspectRatio({
    Key? key,
    Curve curve = Curves.linear,
    required Duration duration,
    required this.aspectRatio,
    this.child,
  })  : assert(aspectRatio.isFinite),
        super(key: key, curve: curve, duration: duration);

  final double aspectRatio;
  final Widget? child;

  @override
  _AnimatedAspectRatioState createState() => _AnimatedAspectRatioState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>('aspectRatio', aspectRatio));
  }
}

class _AnimatedAspectRatioState
    extends AnimatedWidgetBaseState<AnimatedAspectRatio> {
  Tween<double>? _aspectRatio;

  // Called at initState, meaning that _aspectRatio can be evaluated at
  // build.
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _aspectRatio = visitor(_aspectRatio, widget.aspectRatio, (dynamic value) {
      return Tween<double>(begin: value);
    }) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio!.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      DiagnosticsProperty<Tween<double>>(
        'aspectRatio',
        _aspectRatio,
        defaultValue: null,
      ),
    );
  }
}
