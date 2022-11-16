import 'package:flutter/widgets.dart';

import '../../models/app_navigator.dart';
import '../../screens/activity/subscriptions/subscriptions.dart';
import 'subscriptions.props.dart';

class ActivityNavigator extends AppNavigator {
  const ActivityNavigator(super.navigatorKey);
  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Subscriptions.routeName:
        final props = settings.arguments! as SubscriptionsProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => Subscriptions(isBuyer: props.isBuyer),
        );
      default:
        throw UnimplementedError();
    }
  }
}
