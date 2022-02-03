import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../models/product_subscription_plan.dart';
import '../../../../providers/auth.dart';
import '../../../chat/components/chat_avatar.dart';

class SubscriptionPlanDetails extends StatelessWidget {
  final bool isBuyer;
  final bool displayHeader;
  final ProductSubscriptionPlan subscriptionPlan;
  const SubscriptionPlanDetails({
    Key? key,
    this.isBuyer = true,
    this.displayHeader = true,
    required this.subscriptionPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<Auth>().user!;
    final name = isBuyer ? subscriptionPlan.shop.name! : user.displayName!;
    final displayPhoto =
        isBuyer ? subscriptionPlan.shop.image : user.profilePhoto;
    final item = subscriptionPlan.product;
    final disabled = subscriptionPlan.status == 'disabled';

    return Column(
      children: [
        if (displayHeader)
          Row(
            children: [
              Text(
                disabled ? 'Past Subscription' : 'Subscription',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        SizedBox(height: 10.0.h),
        Row(
          children: [
            ChatAvatar(
              displayName: name,
              displayPhoto: displayPhoto ?? '',
              radius: 20.0.r,
            ),
            SizedBox(width: 10.0.w),
            Text(name, style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
        SizedBox(height: 10.0.h),
        Row(
          children: [
            SizedBox(
              width: 40.0.w,
              height: 40.0.w,
              child: Image.network(
                item.image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (ctx, obj, stack) {
                  if (item.image != null) {
                    return const Center(
                      child: Text('Error displaying image.'),
                    );
                  }

                  return const Center(
                    child: Text('No image.'),
                  );
                },
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: Text(
                item.name!,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10.0.w),
            SizedBox(
              width: 50.0.w,
              child: Text(
                'x${subscriptionPlan.quantity}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Text(
              'P ${item.price}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ],
    );
  }
}
