import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppNavigator {
  const AppNavigator(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  Route<dynamic> onGenerateRoute(RouteSettings settings);

  static Route appPageRoute({
    required WidgetBuilder builder,
    String? title,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: builder,
        title: title,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      );
    } else {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      );
    }
  }
}
