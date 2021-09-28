import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/product_subscription_plan.dart';
import '../../../providers/user.dart';
import '../../chat/components/chat_avatar.dart';

class SubscriptionPlanDetails extends StatelessWidget {
  final bool isBuyer;
  final bool displayHeader;
  final ProductSubscriptionPlan subscriptionPlan;
  const SubscriptionPlanDetails({
    Key key,
    this.isBuyer = true,
    this.displayHeader = true,
    @required this.subscriptionPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    final name = isBuyer ? subscriptionPlan.shop.name : user.displayName;
    final displayPhoto =
        isBuyer ? subscriptionPlan.shop.image : user.profilePhoto;
    final item = subscriptionPlan.product;

    return Container(
      child: Column(
        children: [
          if (displayHeader)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subscription",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          SizedBox(height: 10.0.h),
          Row(
            children: [
              ChatAvatar(
                displayName: name,
                displayPhoto: displayPhoto ?? "",
                radius: 20.0.r,
              ),
              SizedBox(width: 10.0.w),
              Text(name, style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
          SizedBox(height: 10.0.h),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 40.0.w,
                  height: 40.0.w,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, obj, stack) {
                      return Text("No Image");
                    },
                  ),
                ),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  'x${subscriptionPlan.quantity}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'P ${item.price}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
