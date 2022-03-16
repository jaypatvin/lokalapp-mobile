import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

import '../../../../models/product_subscription_plan.dart';
import 'subscription_plan.card.dart';

class SubscriptionPlanStream extends StatelessWidget {
  const SubscriptionPlanStream({
    Key? key,
    required this.stream,
    required this.onDetailsPressed,
    this.onConfirmSubscription,
    this.isBuyer = true,
  }) : super(key: key);
  final Stream<List<ProductSubscriptionPlan>> stream;
  final void Function(ProductSubscriptionPlan) onDetailsPressed;
  final void Function(ProductSubscriptionPlan)? onConfirmSubscription;
  final bool isBuyer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductSubscriptionPlan>>(
      initialData: const [],
      stream: stream,
      builder: (ctx, subscriptionPlanSnapshot) {
        if (subscriptionPlanSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!subscriptionPlanSnapshot.hasData ||
            (subscriptionPlanSnapshot.data?.isEmpty ?? true)) {
          return Center(
            child: Text(
              isBuyer ? 'No Subscriptions yet!' : 'No Subscribers!',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            SliverGroupedListView<ProductSubscriptionPlan, SubscriptionStatus>(
              key: Key('${isBuyer ? "buyer" : "seller"}_sliver_group'),
              elements: subscriptionPlanSnapshot.data!,
              groupBy: (subscriptionPlan) => subscriptionPlan.status,
              groupComparator: (status1, status2) {
                if (!isBuyer && status2 == SubscriptionStatus.disabled) {
                  if (status1 == status2) return 0;
                  return 1;
                } else if (!isBuyer && status1 == SubscriptionStatus.disabled) {
                  if (status1 == status2) return 0;
                  return -1;
                }

                return status1.compareTo(status2);
              },
              groupSeparatorBuilder: (SubscriptionStatus status) {
                final String _header;
                switch (status) {
                  case SubscriptionStatus.enabled:
                    _header = 'Active Subscriptions';
                    break;
                  case SubscriptionStatus.cancelled:
                    _header = 'Declined Subscriptions';
                    break;
                  case SubscriptionStatus.unsubscribed:
                    _header = 'Past Subscriptions';
                    break;
                  case SubscriptionStatus.disabled:
                    _header = isBuyer ? 'For Confirmation' : 'To Confirm';
                    break;
                }

                return Container(
                  key: Key('header_$status'),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 10.0.h,
                  ),
                  child: Text(
                    _header,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 18.0.sp),
                  ),
                );
              },
              itemComparator: (a, b) => b.createdAt.compareTo(a.createdAt),
              itemBuilder: (ctx, subscriptionPlan) {
                return SubscriptionPlanCard(
                  key: Key('card_${subscriptionPlan.id}'),
                  isBuyer: isBuyer,
                  subscriptionPlan: subscriptionPlan,
                  onDetailsPressed: onDetailsPressed,
                  onConfirmSubscription: onConfirmSubscription,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
