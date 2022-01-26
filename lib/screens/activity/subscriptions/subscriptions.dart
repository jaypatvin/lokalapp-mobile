import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../models/product_subscription_plan.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/subscriptions/subscriptions.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import 'components/subscription_plan_details.dart';
import 'subscription_details.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({Key? key, required this.isBuyer}) : super(key: key);
  final bool isBuyer;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _SubscriptionsView(),
      viewModel: SubscriptionsViewModel(
        isBuyer: isBuyer,
      ),
    );
  }
}

class _SubscriptionsView extends StatelessView<SubscriptionsViewModel> {
  @override
  Widget render(BuildContext context, SubscriptionsViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: vm.isBuyer ? 'My Subscriptions' : 'Subscription Orders',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: vm.isBuyer ? kTealColor : kPurpleColor,
        onPressedLeading: () => Navigator.of(context).pop(),
      ),
      body: vm.stream != null
          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: vm.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      // return Text('Error: ${snapshot.error}');
                      return const Center(
                        child: Text('There was an unexpected error.'),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No subscriptions yet!',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      );
                    } else {
                      return GroupedListView<
                          QueryDocumentSnapshot<Map<String, dynamic>>, bool?>(
                        physics: const AlwaysScrollableScrollPhysics(),
                        elements: snapshot.data!.docs,
                        groupBy: (snapshot) {
                          final archived = snapshot['archived'] as bool?;
                          return archived;
                        },
                        groupSeparatorBuilder: (bool? archived) {
                          return const SizedBox();
                        },
                        order: GroupedListOrder.DESC,
                        itemBuilder: (context, snapshot) {
                          final subscriptionPlan =
                              ProductSubscriptionPlan.fromDocument(snapshot);
                          return _SubscriptionCard(
                            subscriptionPlan: subscriptionPlan,
                            isBuyer: vm.isBuyer,
                            onDetailsPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SubscriptionDetails(
                                    subscriptionPlan: subscriptionPlan,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        itemComparator: (a, b) {
                          final subA = ProductSubscriptionPlan.fromDocument(a);
                          final subB = ProductSubscriptionPlan.fromDocument(b);
                          return subA.plan.startDates.first
                              .compareTo(subB.plan.startDates.first);
                        },
                      );
                    }
                }
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have not created a shop yet!',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 5.0.h),
                  AppButton.transparent(
                    text: 'Create Shop',
                    color: kPurpleColor,
                    onPressed: vm.createShopHandler,
                  ),
                ],
              ),
            ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final void Function()? onDetailsPressed;
  final bool isBuyer;
  final ProductSubscriptionPlan subscriptionPlan;
  const _SubscriptionCard({
    Key? key,
    required this.subscriptionPlan,
    this.onDetailsPressed,
    this.isBuyer = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool disabled = subscriptionPlan.status == 'disabled';

    return Card(
      margin: EdgeInsets.only(top: 10.0.h, left: 10.w, right: 10.w),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      color: disabled ? Colors.grey.shade200 : const Color(0xFFF1FAFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
        child: Column(
          children: [
            SubscriptionPlanDetails(
              subscriptionPlan: subscriptionPlan,
              isBuyer: isBuyer,
            ),
            SizedBox(height: 15.0.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.transparent(
                text: 'Details',
                onPressed: onDetailsPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
