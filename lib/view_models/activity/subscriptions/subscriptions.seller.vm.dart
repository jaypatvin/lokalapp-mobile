import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api_service.dart';
import '../../../services/database/collections/product_subscription_plans.collection.dart';
import '../../../services/database/database.dart';
import '../../../state/view_model.dart';

class SubscriptionsSellerViewModel extends ViewModel {
  late final ProductSubscriptionPlansCollection _db;
  late final SubscriptionPlanAPIService _subscriptionPlanApiService;

  Stream<List<ProductSubscriptionPlan>>? _subscriptionPlanStream;
  Stream<List<ProductSubscriptionPlan>>? get subscriptionPlanStream =>
      _subscriptionPlanStream;

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    super.init();
    final _api = context.read<API>();
    _db = context.read<Database>().productSubscriptionPlans;
    _subscriptionPlanApiService = SubscriptionPlanAPIService(_api);

    final _user = context.read<Auth>().user!;
    final _shops = context.read<Shops>().findByUser(_user.id);

    if (_shops.isNotEmpty) {
      _setUpStreams();
    } else {
      context.read<Shops>().addListener(_shopChangeListener);
    }
  }

  void _shopChangeListener() {
    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);
    if (shops.isEmpty) return;

    _setUpStreams();
    context.read<Shops>().removeListener(_shopChangeListener);
    notifyListeners();
  }

  void _setUpStreams() {
    final _user = context.read<Auth>().user!;
    // we're sure that there is a shop
    final _shop = context.read<Shops>().findByUser(_user.id).first;
    _subscriptionPlanStream = _db.getShopSubscriptionPlans(_shop.id);
  }

  void createShopHandler() {
    _appRouter.jumpToTab(AppRoute.profile);
  }

  void onDetailsPressed(
    ProductSubscriptionPlan productSubscriptionPlan,
  ) {
    _appRouter.navigateTo(
      AppRoute.activity,
      ActivityRoutes.subscriptionPlanScreen,
      arguments: SubscriptionPlanScreenArguments(
        subscriptionPlan: productSubscriptionPlan,
        isBuyer: false,
      ),
    );
  }

  Future<void> onConfirm(ProductSubscriptionPlan plan) async {
    try {
      await _subscriptionPlanApiService.confirmSubscriptionPlan(
        planId: plan.id,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e.toString());
    }
  }
}
