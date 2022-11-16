import 'package:flutter/material.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

import '../../../../models/product_subscription_plan.dart';
import 'subscription_plan.card.dart';

class SubscriptionPlanStream extends StatelessWidget {
  const SubscriptionPlanStream({
    super.key,
    required this.stream,
    required this.onDetailsPressed,
    this.onConfirmSubscription,
    this.isBuyer = true,
  });
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
                final String header;
                switch (status) {
                  case SubscriptionStatus.enabled:
                    header = 'Active Subscriptions';
                    break;
                  case SubscriptionStatus.cancelled:
                    header = 'Declined Subscriptions';
                    break;
                  case SubscriptionStatus.unsubscribed:
                    header = 'Past Subscriptions';
                    break;
                  case SubscriptionStatus.disabled:
                    header = isBuyer ? 'For Confirmation' : 'To Confirm';
                    break;
                }

                return Container(
                  key: Key('header_$status'),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                  child: Text(
                    header,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                );
              },
              itemComparator: (a, b) => b.createdAt.compareTo(a.createdAt),
              itemBuilder: (ctx, subscriptionPlan) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SubscriptionPlanCard(
                    key: Key('card_${subscriptionPlan.id}'),
                    isBuyer: isBuyer,
                    subscriptionPlan: subscriptionPlan,
                    onDetailsPressed: onDetailsPressed,
                    onConfirmSubscription: onConfirmSubscription,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
