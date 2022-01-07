import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../state/view_model.dart';
import '../../state/views/hook.view.dart';

/// Imported from https://pub.dev/packages/screen_loader
mixin ScreenLoader<T extends StatefulWidget> on State<T> {
  bool isLoading = false;
  static Widget? _globalLoader;
  static double? _globalLoadingBgBlur = 5.0;

  /// starts the [loader]
  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  /// stops the [loader]
  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  /// DO NOT use this method in FutureBuilder because this methods
  /// updates the state which will make future builder to call
  /// this function again and it will go in loop
  Future<T?> performFuture<T>(Function futureCallback) async {
    startLoading();
    final T? data = await futureCallback();
    stopLoading();
    return data;
  }

  /// override [loadingBgBlur] if you wish to change blur value in specific view
  double? loadingBgBlur() {
    return null;
  }

  double _loadingBgBlur() {
    return loadingBgBlur() ?? ScreenLoader._globalLoadingBgBlur ?? 5.0;
  }

  /// override [loader] if you wish to add custom loader in specific view
  Widget? loader() {
    return null;
  }

  Widget _loader() {
    return loader() ??
        ScreenLoader._globalLoader ??
        const CircularProgressIndicator();
  }

  Widget _buildLoader() {
    if (isLoading) {
      return Container(
        color: Colors.transparent,
        child: Center(
          child: _loader(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget screen(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        screen(context),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _loadingBgBlur(),
            sigmaY: _loadingBgBlur(),
          ),
          child: _buildLoader(),
        ),
      ],
    );
  }
}

mixin HookScreenLoader<T extends ViewModel> on HookView<T> {
  static Widget? _globalLoader;
  static double? _globalLoadingBgBlur = 5.0;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// starts the [loader]
  void startLoading() {
    isLoading.value = true;
  }

  /// stops the [loader]
  void stopLoading() {
    isLoading.value = false;
  }

  /// DO NOT use this method in FutureBuilder because this methods
  /// updates the state which will make future builder to call
  /// this function again and it will go in loop
  Future<T?> performFuture<T>(Function futureCallback) async {
    startLoading();
    final T? data = await futureCallback();
    stopLoading();
    return data;
  }

  /// override [loadingBgBlur] if you wish to change blur value in specific view
  double? loadingBgBlur() {
    return null;
  }

  double _loadingBgBlur() {
    return loadingBgBlur() ?? HookScreenLoader._globalLoadingBgBlur ?? 5.0;
  }

  /// override [loader] if you wish to add custom loader in specific view
  Widget? loader() {
    return null;
  }

  Widget _loader() {
    return loader() ??
        HookScreenLoader._globalLoader ??
        const CircularProgressIndicator();
  }

  Widget _buildLoader(bool isLoading) {
    if (isLoading) {
      return Container(
        color: Colors.transparent,
        child: Center(
          child: _loader(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget screen(BuildContext context, T viewModel);

  @override
  Widget render(BuildContext context, T viewModel) {
    final isLoading = useState(this.isLoading.value);

    useEffect(
      () {
        void listener() {
          isLoading.value = this.isLoading.value;
        }

        this.isLoading.addListener(listener);

        return () => this.isLoading.removeListener(listener);
      },
      [this.isLoading],
    );

    return Stack(
      children: <Widget>[
        screen(context, viewModel),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _loadingBgBlur(),
            sigmaY: _loadingBgBlur(),
          ),
          child: _buildLoader(isLoading.value),
        ),
      ],
    );
  }
}

/// [ScreenLoaderApp] is used to provide global settings for the screen loader
class ScreenLoaderApp extends StatelessWidget {
  final MaterialApp app;
  final Widget? globalLoader;
  final double? globalLoadingBgBlur;

  const ScreenLoaderApp({
    required this.app,
    this.globalLoader,
    this.globalLoadingBgBlur,
  });

  @override
  Widget build(BuildContext context) {
    ScreenLoader._globalLoader = globalLoader;
    HookScreenLoader._globalLoader = globalLoader;
    ScreenLoader._globalLoadingBgBlur = globalLoadingBgBlur;
    HookScreenLoader._globalLoadingBgBlur = globalLoadingBgBlur;
    return app;
  }
}
