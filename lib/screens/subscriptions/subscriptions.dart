import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../../models/product_subscription_plan.dart';
import '../../providers/auth.dart';
import '../../providers/shops.dart';
import '../../services/database.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import 'components/subscription_plan_details.dart';
import 'subscription_details.dart';

class Subscriptions extends StatefulWidget {
  final bool isBuyer;
  const Subscriptions({Key? key, required this.isBuyer}) : super(key: key);

  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  Stream<QuerySnapshot>? _stream;
  @override
  void initState() {
    super.initState();
    final user = context.read<Auth>().user!;

    if (widget.isBuyer) {
      _stream = Database.instance.getUserSubscriptions(user.id);
    } else {
      final shops = context.read<Shops>().findByUser(user.id);
      if (shops.isNotEmpty) {
        final shop = shops.first;
        _stream = Database.instance.getShopSubscribers(shop.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: widget.isBuyer ? "My Subscriptions" : "Subscription Orders",
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: widget.isBuyer ? kTealColor : kPurpleColor,
        onPressedLeading: () => Navigator.of(context).pop(),
      ),
      body: StreamBuilder(
        stream: this._stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (!snapshot.hasData || snapshot.data!.docs.length == 0)
                return Center(
                  child: Text(
                    'No subscriptions yet!',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                );
              else {
                return GroupedListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  elements: snapshot.data!.docs,
                  groupBy: (QueryDocumentSnapshot snapshot) {
                    final archived = snapshot["archived"] as bool?;
                    return archived;
                  },
                  groupSeparatorBuilder: (dynamic archived) {
                    return const SizedBox();
                  },
                  order: GroupedListOrder.DESC,
                  itemBuilder: (context, QueryDocumentSnapshot snapshot) {
                    final snapshotData =
                        snapshot.data() as Map<String, dynamic>;
                    final data = {
                      ...snapshotData,
                      "id": snapshot.id,
                    };
                    final subscriptionPlan =
                        ProductSubscriptionPlan.fromMap(data);
                    return _SubscriptionCard(
                      subscriptionPlan: subscriptionPlan,
                      isBuyer: widget.isBuyer,
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
                  itemComparator:
                      (QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
                    final subA = ProductSubscriptionPlan.fromMap(
                        a.data() as Map<String, dynamic>);
                    final subB = ProductSubscriptionPlan.fromMap(
                        b.data() as Map<String, dynamic>);

                    return subA.plan.startDates.first
                        .compareTo(subB.plan.startDates.first);
                  },
                );
              }
          }
        },
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
    return Card(
      margin: EdgeInsets.only(top: 10.0.h, left: 10.w, right: 10.w),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      color: Color(0xFFF1FAFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
        child: Column(
          children: [
            SubscriptionPlanDetails(
              subscriptionPlan: this.subscriptionPlan,
              isBuyer: this.isBuyer,
            ),
            SizedBox(height: 15.0.h),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Details",
                kTealColor,
                false,
                this.onDetailsPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
