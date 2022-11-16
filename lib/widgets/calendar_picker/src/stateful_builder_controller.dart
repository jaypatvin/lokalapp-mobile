import 'package:flutter/material.dart';

typedef StatefulWidgetBuilder1<T> = Widget Function(
  BuildContext context,
  StateSetter setState,
  T value,
);
typedef StatefulWidgetBuilder2<T1, T2> = Widget Function(
  BuildContext context,
  StateSetter setState,
  T1 t1,
  T2 t2,
);
typedef StatefulWidgetBuilder3<T1, T2, T3> = Widget Function(
  BuildContext context,
  StateSetter setState,
  T1 t1,
  T2 t2,
  T3 t3,
);
typedef StatefulWidgetBuilder4<T1, T2, T3, T4> = Widget Function(
  BuildContext context,
  StateSetter setState,
  T1 t1,
  T2 t2,
  T3 t3,
  T4 t4,
);
typedef StatefulWidgetBuilder5<T1, T2, T3, T4, T5> = Widget Function(
  BuildContext context,
  StateSetter setState,
  T1 t1,
  T2 t2,
  T3 t3,
  T4 t4,
  T5 t5,
);

/// control setState for StatefulWidget
///
/// Example:
///
/// 0. define property for widget
/// double headerHeight = 100;
///
/// 1. create controller
/// final setterController = SetterController();
///
/// 2. create StatefulBuilder1
/// StatefulBuilder1(
///   controller: setterController,
///   builder: (context, setter, value) {
///     return Container(
///       height: headerHeight,
///       color: Colors.red,
///       alignment: Alignment.center,
///       child: value,
///     );
///   },
///   value: Text("ddd"),
/// )
///
/// 3. update headerHeight and reload StatefulBuilder1 only
/// setterController.update(() {
///   headerHeight = 200;
/// });
class SetterController {
  StateSetter? _stateSetter;

  /// call setState for StatefulWidget
  void update(VoidCallback fn) {
    _stateSetter?.call(fn);
  }
}

class _StatefulBuilderBase extends StatefulWidget {
  const _StatefulBuilderBase({
    super.key,
    required this.builder,
    required this.controller,
  });

  final SetterController controller;
  final StatefulWidgetBuilder builder;

  @override
  _StatefulBuilderState createState() =>
      _StatefulBuilderState<_StatefulBuilderBase>();
}

class _StatefulBuilderState<T extends _StatefulBuilderBase> extends State<T> {
  @override
  void initState() {
    super.initState();
    widget.controller._stateSetter = setState;
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}

/// StatefulBuilder with SetterController
class StatefulBuilder0<T> extends _StatefulBuilderBase {
  const StatefulBuilder0({
    super.key,
    required super.builder,
    required super.controller,
  });
}

/// StatefulBuilder with single property value and SetterController
class StatefulBuilder1<T> extends _StatefulBuilderBase {
  StatefulBuilder1({
    super.key,
    required StatefulWidgetBuilder1<T?> builder,
    required super.controller,
    T? value,
  }) : super(
          builder: (context, setter) => builder(context, setter, value),
        );
}

/// StatefulBuilder with two property value and SetterController
class StatefulBuilder2<T1, T2> extends _StatefulBuilderBase {
  StatefulBuilder2({
    super.key,
    required StatefulWidgetBuilder2<T1?, T2?> builder,
    required super.controller,
    T1? value1,
    T2? value2,
  }) : super(
          builder: (context, setter) =>
              builder(context, setter, value1, value2),
        );
}

/// StatefulBuilder with three property value and SetterController
class StatefulBuilder3<T1, T2, T3> extends _StatefulBuilderBase {
  StatefulBuilder3({
    super.key,
    required StatefulWidgetBuilder3<T1?, T2?, T3?> builder,
    required super.controller,
    T1? value1,
    T2? value2,
    T3? value3,
  }) : super(
          builder: (context, setter) =>
              builder(context, setter, value1, value2, value3),
        );
}

/// StatefulBuilder with four property value and SetterController
class StatefulBuilder4<T1, T2, T3, T4> extends _StatefulBuilderBase {
  StatefulBuilder4({
    super.key,
    required StatefulWidgetBuilder4<T1?, T2?, T3?, T4?> builder,
    required super.controller,
    T1? value1,
    T2? value2,
    T3? value3,
    T4? value4,
  }) : super(
          builder: (context, setter) =>
              builder(context, setter, value1, value2, value3, value4),
        );
}

/// StatefulBuilder with four property value and SetterController
class StatefulBuilder5<T1, T2, T3, T4, T5> extends _StatefulBuilderBase {
  StatefulBuilder5({
    super.key,
    required StatefulWidgetBuilder5<T1?, T2?, T3?, T4?, T5?> builder,
    required super.controller,
    T1? value1,
    T2? value2,
    T3? value3,
    T4? value4,
    T5? value5,
  }) : super(
          builder: (context, setter) => builder(
            context,
            setter,
            value1,
            value2,
            value3,
            value4,
            value5,
          ),
        );
}
