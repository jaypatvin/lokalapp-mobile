import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/subscriptions/subscription_plan.screen.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api_service.dart';
import '../../../services/database.dart';
import '../../../state/view_model.dart';

class SubscriptionsSellerViewModel extends ViewModel {
  late final Database _db;
  late final SubscriptionPlanAPIService _subscriptionPlanApiService;

  Stream<List<ProductSubscriptionPlan>>? _subscriptionPlanStream;
  Stream<List<ProductSubscriptionPlan>>? get subscriptionPlanStream =>
      _subscriptionPlanStream;

  @override
  void init() {
    super.init();
    final _api = context.read<API>();
    _db = Database.instance;
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

    _subscriptionPlanStream = _db
        .getShopSubscriptionPlans(_shop.id)
        .map<List<ProductSubscriptionPlan>>((snapshot) => snapshot.docs
            .map<ProductSubscriptionPlan>(
                // ignore: require_trailing_commas
                (doc) => ProductSubscriptionPlan.fromDocument(doc))
            // ignore: require_trailing_commas
            .toList());
  }

  void createShopHandler() {
    context.read<AppRouter>().jumpToTab(AppRoute.profile);
  }

  void onDetailsPressed(
    ProductSubscriptionPlan productSubscriptionPlan,
  ) {
    AppRouter.activityNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => SubscriptionPlanScreen(
          subscriptionPlan: productSubscriptionPlan,
          isBuyer: false,
        ),
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
