import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../services/database/collections/product_subscription_plans.collection.dart';
import '../../../services/database/database.dart';
import '../../../state/view_model.dart';

class SubscriptionsBuyerViewModel extends ViewModel {
  late final ProductSubscriptionPlansCollection _db;

  late Stream<List<ProductSubscriptionPlan>> _subscriptionPlanStream;
  Stream<List<ProductSubscriptionPlan>> get subscriptionPlanStream =>
      _subscriptionPlanStream;

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    super.init();
    _db = context.read<Database>().productSubscriptionPlans;

    final _user = context.read<Auth>().user!;

    _subscriptionPlanStream = _db.getUserSubscriptionPlans(_user.id);
  }

  void onDetailsPressed(ProductSubscriptionPlan subscriptionPlan) {
    _appRouter.navigateTo(
      AppRoute.activity,
      ActivityRoutes.subscriptionPlanScreen,
      arguments: SubscriptionPlanScreenArguments(
        subscriptionPlan: subscriptionPlan,
      ),
    );
  }
}
