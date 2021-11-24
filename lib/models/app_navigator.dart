import 'package:flutter/widgets.dart';

abstract class AppNavigator {
  const AppNavigator(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  Route<dynamic> onGenerateRoute(RouteSettings settings);
}
