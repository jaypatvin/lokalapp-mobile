import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/operating_hours.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../routers/chat/props/chat_details.props.dart';
import '../../../routers/discover/product_detail.props.dart';
import '../../../screens/activity/subscriptions/subscription_schedule.dart';
import '../../../screens/chat/chat_details.dart';
import '../../../screens/discover/product_detail.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api_service.dart';
import '../../../state/view_model.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';

class SubscriptionPlanScreenViewModel extends ViewModel {
  SubscriptionPlanScreenViewModel({
    required this.subscriptionPlan,
    required this.isBuyer,
  });

  final ProductSubscriptionPlan subscriptionPlan;
  final bool isBuyer;
  late final SubscriptionPlanAPIService _apiService;

  @override
  void init() {
    _apiService = SubscriptionPlanAPIService(context.read<API>());
  }

  double get orderTotal =>
      subscriptionPlan.quantity * subscriptionPlan.product.price;

  bool checkForConflicts() {
    if (subscriptionPlan.plan.autoReschedule) return false;

    final _generator = ScheduleGenerator();
    final product = context.read<Products>().findById(
          subscriptionPlan.productId,
        );

    // only needed for operatingHours
    final shop = context.read<Shops>().findById(subscriptionPlan.shopId)!;

    final operatingHours = OperatingHours(
      repeatType: subscriptionPlan.plan.repeatType,
      repeatUnit: subscriptionPlan.plan.repeatUnit,
      startDates: subscriptionPlan.plan.startDates
          .map<String>((date) => DateFormat('yyyy-MM-dd').format(date))
          .toList(),
      customDates: [],
      startTime: shop.operatingHours.startTime,
      endTime: shop.operatingHours.endTime,
    );

    // product schedule initialization
    final productSelectableDates = _generator
        .getSelectableDates(product!.availability)
        .where(
          (date) =>
              date.difference(DateTime.now()).inDays <= 45 &&
              date.difference(DateTime.now()).inDays >= 0,
        )
        .toList()
      ..sort();

    final markedDates = _generator
        .getSelectableDates(operatingHours)
        .where(
          (date) =>
              date.difference(DateTime.now()).inDays <= 45 &&
              date.difference(DateTime.now()).inDays >= 0,
        )
        .toList()
      ..sort();

    for (final overrideDate in subscriptionPlan.plan.overrideDates) {
      final index = markedDates.indexWhere(
        (date) => date.compareTo(overrideDate.originalDate) == 0,
      );
      if (index > -1) {
        markedDates[index] = overrideDate.newDate;
      }
    }

    return markedDates
        .toSet()
        .difference(productSelectableDates.toSet())
        .isNotEmpty;
  }

  void onSeeSchedule() {
    final SubscriptionSchedule _screen;
    if (isBuyer) {
      _screen = SubscriptionSchedule.view(
        subscriptionPlan: subscriptionPlan,
      );
    } else {
      _screen = SubscriptionSchedule.seller(
        subscriptionPlan: subscriptionPlan,
      );
    }

    AppRouter.activityNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => _screen,
      ),
    );
  }

  void onMessageSend() {
    context.read<AppRouter>().navigateTo(
          AppRoute.chat,
          ChatDetails.routeName,
          arguments: ChatDetailsProps(
            members: [
              subscriptionPlan.buyerId,
              subscriptionPlan.shopId,
            ],
            shopId: subscriptionPlan.shopId,
            productId: subscriptionPlan.productId,
          ),
        );
  }

  void onSubscribeAgain() {
    final _product = context.read<Products>().findById(
          subscriptionPlan.productId,
        );
    if (_product != null) {
      context.read<AppRouter>().navigateTo(
            AppRoute.discover,
            ProductDetail.routeName,
            arguments: ProductDetailProps(
              _product,
            ),
          );
    } else {
      showToast('Sorry, the product has been removed.');
    }
  }

  Future<void> onUnsubscribe() async {
    try {
      // this will throw an error if unsuccessful
      final _success = await _apiService.unsubscribeFromSubscriptionPlan(
        planId: subscriptionPlan.id,
      );

      if (!_success) {
        throw FailureException('Failed to unsubscribe. Try again.');
      }

      AppRouter.activityNavigatorKey.currentState?.pop();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> onConfirmSubscription() async {
    try {
      final _success = await _apiService.confirmSubscriptionPlan(
        planId: subscriptionPlan.id,
      );
      if (!_success) {
        throw FailureException('Failed to confirm subscription. Try again.');
      }

      AppRouter.activityNavigatorKey.currentState?.pop();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> onDeclineSubscription() async {
    try {
      final _success = await _apiService.cancelSubscriptionPlan(
        planId: subscriptionPlan.id,
      );
      if (!_success) {
        throw FailureException(
          'Failed to decline the subscription. Try again.',
        );
      }

      AppRouter.activityNavigatorKey.currentState?.pop();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
