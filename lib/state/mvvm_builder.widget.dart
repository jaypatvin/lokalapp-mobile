import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model.dart';

/// The MVVM builder widget.
class MVVM<T extends ViewModel> extends StatefulWidget {
  const MVVM({
    Key? key,
    required this.view,
    required this.viewModel,
    this.disposeVM = true,
    this.implicitView = true,
    this.initOnce = false,
  }) : super(key: key);

  /// This is the builder function for the View widget which also has access
  /// to the [viewModel]
  final Widget Function(BuildContext, T) view;

  /// The view model of the [view];
  final T viewModel;

  /// Whether to dispose the [viewModel] when the provider is removed from the
  /// widget tree.
  final bool disposeVM;

  /// Whether the [viewModel] should be initialized once or every time the
  /// dependencies change.
  ///
  /// Set to true to ignore dependencies updates.
  final bool initOnce;

  /// Whether the [view] builder is returning a predefined widget class -
  /// implicit view - (i.e., [StatelessView], [HookView], [StatefulWidget], and
  /// [StatelessWidget]) or returning a dynamic widget.
  ///
  /// When the [implicitView] is `true`, then the view widget is wrapped with
  /// a [Consumer] widget to make it listen to the view model changes.
  final bool implicitView;

  @override
  _MVVMState<T> createState() => _MVVMState<T>();
}

class _MVVMState<T extends ViewModel> extends State<MVVM<T>>
    with WidgetsBindingObserver {
  late T _vm;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _vm = widget.viewModel;

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _vm.onResume();
        break;
      case AppLifecycleState.inactive:
        _vm.onInactive();
        break;
      case AppLifecycleState.paused:
        _vm.onPause();
        break;
      case AppLifecycleState.detached:
        _vm.onDetach();
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (identical(_vm, widget.viewModel)) {
      _vm = widget.viewModel;
    }

    _vm.context = context;

    if (widget.initOnce && !_initialized) {
      _vm.init();
      _initialized = true;
    } else if (!widget.initOnce) {
      _vm.init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _vm.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vm.onBuild();

    if (widget.implicitView) {
      if (!widget.disposeVM) {
        return ChangeNotifierProvider<T>.value(
          value: _vm,
          child: widget.view(context, _vm),
        );
      }

      return ChangeNotifierProvider(
        create: (_) => _vm,
        child: widget.view(context, _vm),
      );
    }

    if (!widget.disposeVM) {
      return ChangeNotifierProvider<T>.value(
        value: _vm,
        child: Consumer<T>(
          builder: (context, vm, _) => widget.view(context, vm),
        ),
      );
    }

    return ChangeNotifierProvider<T>(
      create: (_) => _vm,
      child: Consumer<T>(
        builder: (context, vm, _) => widget.view(context, vm),
      ),
    );
  }
}
