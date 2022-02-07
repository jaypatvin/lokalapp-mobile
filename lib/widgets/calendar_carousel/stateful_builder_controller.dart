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
    Key? key,
    required this.builder,
    required this.controller,
  }) : super(key: key);

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
    Key? key,
    required StatefulWidgetBuilder builder,
    required SetterController controller,
  }) : super(key: key, builder: builder, controller: controller);
}

/// StatefulBuilder with single property value and SetterController
class StatefulBuilder1<T> extends _StatefulBuilderBase {
  StatefulBuilder1({
    Key? key,
    required StatefulWidgetBuilder1<T?> builder,
    required SetterController controller,
    T? value,
  }) : super(
          key: key,
          builder: (context, setter) => builder(context, setter, value),
          controller: controller,
        );
}

/// StatefulBuilder with two property value and SetterController
class StatefulBuilder2<T1, T2> extends _StatefulBuilderBase {
  StatefulBuilder2({
    Key? key,
    required StatefulWidgetBuilder2<T1?, T2?> builder,
    required SetterController controller,
    T1? value1,
    T2? value2,
  }) : super(
          key: key,
          builder: (context, setter) =>
              builder(context, setter, value1, value2),
          controller: controller,
        );
}

/// StatefulBuilder with three property value and SetterController
class StatefulBuilder3<T1, T2, T3> extends _StatefulBuilderBase {
  StatefulBuilder3({
    Key? key,
    required StatefulWidgetBuilder3<T1?, T2?, T3?> builder,
    required SetterController controller,
    T1? value1,
    T2? value2,
    T3? value3,
  }) : super(
          key: key,
          builder: (context, setter) =>
              builder(context, setter, value1, value2, value3),
          controller: controller,
        );
}

/// StatefulBuilder with four property value and SetterController
class StatefulBuilder4<T1, T2, T3, T4> extends _StatefulBuilderBase {
  StatefulBuilder4({
    Key? key,
    required StatefulWidgetBuilder4<T1?, T2?, T3?, T4?> builder,
    required SetterController controller,
    T1? value1,
    T2? value2,
    T3? value3,
    T4? value4,
  }) : super(
          key: key,
          builder: (context, setter) =>
              builder(context, setter, value1, value2, value3, value4),
          controller: controller,
        );
}

/// StatefulBuilder with four property value and SetterController
class StatefulBuilder5<T1, T2, T3, T4, T5> extends _StatefulBuilderBase {
  StatefulBuilder5({
    Key? key,
    required StatefulWidgetBuilder5<T1?, T2?, T3?, T4?, T5?> builder,
    required SetterController controller,
    T1? value1,
    T2? value2,
    T3? value3,
    T4? value4,
    T5? value5,
  }) : super(
          key: key,
          builder: (context, setter) => builder(
            context,
            setter,
            value1,
            value2,
            value3,
            value4,
            value5,
          ),
          controller: controller,
        );
}
