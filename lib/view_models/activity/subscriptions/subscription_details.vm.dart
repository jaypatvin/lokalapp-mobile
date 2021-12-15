import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/operating_hours.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../routers/chat/chat_view.props.dart';
import '../../../screens/activity/subscriptions/subscription_schedule.dart';
import '../../../screens/chat/chat_view.dart';
import '../../../state/view_model.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';

class SubscriptionDetailsViewModel extends ViewModel {
  SubscriptionDetailsViewModel({
    required this.subscriptionPlan,
    required this.isBuyer,
  });

  final ProductSubscriptionPlan subscriptionPlan;
  final bool isBuyer;

  double get orderTotal =>
      subscriptionPlan.quantity! * subscriptionPlan.product.price!;

  bool checkForConflicts() {
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
          .map<String>((date) => DateFormat("yyyy-MM-dd").format(date))
          .toList(),
      unavailableDates: subscriptionPlan.plan.unavailableDates
          .map<String>((date) => DateFormat("yyyy-MM-dd").format(date))
          .toList(),
      customDates: [],
      startTime: shop.operatingHours!.startTime,
      endTime: shop.operatingHours!.endTime,
    );

    // product schedule initialization
    final productSelectableDates = _generator
        .getSelectableDates(product!.availability!)
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

    subscriptionPlan.plan.overrideDates.forEach((overrideDate) {
      final index = markedDates.indexWhere(
          (date) => date.compareTo(overrideDate.originalDate!) == 0);
      if (index > -1) {
        markedDates[index] = overrideDate.newDate;
      }
    });

    return !subscriptionPlan.plan.autoReschedule! &&
        markedDates
            .toSet()
            .difference(productSelectableDates.toSet())
            .isNotEmpty;
  }

  void onSeeSchedule() {
    AppRouter.pushNewScreen(
      context,
      screen: SubscriptionSchedule(
        subscriptionPlan: subscriptionPlan,
      ),
    );
  }

  void onMessageSend() {
    context
      ..read<AppRouter>().navigateTo(
        AppRoute.chat,
        ChatView.routeName,
        arguments: ChatViewProps(
          true,
          members: [
            subscriptionPlan.buyerId!,
            subscriptionPlan.shopId!,
          ],
          shopId: subscriptionPlan.shopId,
        ),
      );
  }

  void onUnsubscribe() => null;
}
