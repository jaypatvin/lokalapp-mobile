import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/failure_exception.dart';
import '../../../models/operating_hours.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
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
  final _appRouter = locator<AppRouter>();

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
    if (isBuyer) {
      _appRouter.navigateTo(
        AppRoute.activity,
        ActivityRoutes.subscriptionScheduleBuyer,
        arguments: SubscriptionScheduleBuyerArguments(
          subscriptionPlan: subscriptionPlan,
        ),
      );
    } else {
      _appRouter.navigateTo(
        AppRoute.activity,
        ActivityRoutes.subscriptionScheduleSeller,
        arguments: SubscriptionScheduleSellerArguments(
          subscriptionPlan: subscriptionPlan,
        ),
      );
    }
  }

  void onMessageSend() {
    _appRouter.navigateTo(
      AppRoute.chat,
      ChatRoutes.chatDetails,
      arguments: ChatDetailsArguments(
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
      _appRouter.navigateTo(
        AppRoute.discover,
        DiscoverRoutes.productDetail,
        arguments: ProductDetailArguments(
          product: _product,
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

      _appRouter.popScreen(AppRoute.activity);
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

      _appRouter.popScreen(AppRoute.activity);
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

      _appRouter.popScreen(AppRoute.activity);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
