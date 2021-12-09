import 'package:flutter/widgets.dart';

import '../../models/app_navigator.dart';

class ActivityNavigator extends AppNavigator {
  const ActivityNavigator(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);
  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        throw UnimplementedError();
    }
  }
}
