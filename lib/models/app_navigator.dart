import 'package:flutter/widgets.dart';

abstract class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Route<dynamic> onGenerateRoute(RouteSettings settings);
}
