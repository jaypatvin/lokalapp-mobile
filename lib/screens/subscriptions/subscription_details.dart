import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/operating_hours.dart';
import '../../models/product_subscription_plan.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../chat/chat_view.dart';
import 'components/subscription_plan_details.dart';
import 'subscription_schedule.dart';

// This Widget will display all states/conditions of the order details to avoid
// code repetition.
class SubscriptionDetails extends StatelessWidget {
  final bool isBuyer;
  final ProductSubscriptionPlan subscriptionPlan;
  const SubscriptionDetails({
    @required this.subscriptionPlan,
    this.isBuyer = true,
  });

  Widget buildTextInfo(BuildContext context) {
    final _address = context.read<CurrentUser>().address;
    final address = _address.street +
        ", " +
        _address.barangay +
        ", " +
        _address.subdivision +
        " " +
        _address.city;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes:",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            subscriptionPlan.instruction,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 16.0.h),
          Text(
            "Delivery Address:",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            address,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 16.0.h),
        ],
      ),
    );
  }

  bool _checkForConflicts(BuildContext context) {
    final _generator = ScheduleGenerator();
    final product =
        context.read<Products>().findById(subscriptionPlan.productId);

    // only needed for operatingHours
    final shop = context.read<Shops>().findById(subscriptionPlan.shopId);

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
      startTime: shop.operatingHours.startTime,
      endTime: shop.operatingHours.endTime,
    );

    // product schedule initialization
    final productSelectableDates = _generator
        .getSelectableDates(product.availability)
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
      final index = markedDates
          .indexWhere((date) => date.compareTo(overrideDate.originalDate) == 0);
      if (index > -1) {
        markedDates[index] = overrideDate.newDate;
      }
    });

    return !subscriptionPlan.plan.autoReschedule &&
        markedDates
            .toSet()
            .difference(productSelectableDates.toSet())
            .isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: this.isBuyer ? kTealColor : Color(0xFF57183F),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Order Details",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
            ),
            Text(
              "Subscription",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 36.0.w,
          vertical: 24.0.h,
        ),
        child: Column(
          children: [
            SubscriptionPlanDetails(
              isBuyer: isBuyer,
              displayHeader: false,
              subscriptionPlan: this.subscriptionPlan,
            ),
            Divider(),
            Container(
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    text: "Order Total\t",
                    children: [
                      TextSpan(
                        text:
                            "P ${subscriptionPlan.quantity * subscriptionPlan.product.price}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.orange),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0.h),
            buildTextInfo(context),
            //SizedBox(height: 16.0.h),
            Spacer(),
            _SubscriptionDetailsButtons(
              subscriptionPlan: subscriptionPlan,
              isBuyer: this.isBuyer,
              displayWarning: _checkForConflicts(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionDetailsButtons extends StatelessWidget {
  final bool isBuyer;
  final ProductSubscriptionPlan subscriptionPlan;
  final bool displayWarning;
  const _SubscriptionDetailsButtons({
    Key key,
    @required this.subscriptionPlan,
    @required this.displayWarning,
    this.isBuyer = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FlatButton(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: kTealColor),
            ),
            textColor: kTealColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "See Schedule",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: kTealColor),
                ),
                if (displayWarning)
                  Icon(
                    MdiIcons.alertCircle,
                    color: kPinkColor,
                    size: 20.0.r,
                  )
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SubscriptionSchedule(
                    subscriptionPlan: subscriptionPlan,
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                "Unsubscribe",
                kPinkColor,
                false,
                // TODO: add unsubscribe
                null,
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: AppButton(
                this.isBuyer ? "Message Seller" : "Message Buyer",
                kTealColor,
                false,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ChatView(
                        true,
                        members: [
                          subscriptionPlan.buyerId,
                          subscriptionPlan.shopId
                        ],
                        shopId: subscriptionPlan.shopId,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
