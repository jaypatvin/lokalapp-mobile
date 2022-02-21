import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/subscriptions/subscription_plan.screen.dart';
import '../../../services/database.dart';
import '../../../state/view_model.dart';

class SubscriptionsBuyerViewModel extends ViewModel {
  late final Database _db;

  late Stream<List<ProductSubscriptionPlan>> _subscriptionPlanStream;
  Stream<List<ProductSubscriptionPlan>> get subscriptionPlanStream =>
      _subscriptionPlanStream;

  @override
  void init() {
    super.init();
    _db = Database.instance;

    final _user = context.read<Auth>().user!;

    _subscriptionPlanStream = _db
        .getUserSubscriptionPlans(_user.id)
        .map<List<ProductSubscriptionPlan>>((snapshot) => snapshot.docs
            .map<ProductSubscriptionPlan>(
                // ignore: require_trailing_commas
                (doc) => ProductSubscriptionPlan.fromDocument(doc))
            // ignore: require_trailing_commas
            .toList());
  }

  void onDetailsPressed(ProductSubscriptionPlan subscriptionPlan) {
    AppRouter.activityNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => SubscriptionPlanScreen(
          subscriptionPlan: subscriptionPlan,
        ),
      ),
    );
  }
}
