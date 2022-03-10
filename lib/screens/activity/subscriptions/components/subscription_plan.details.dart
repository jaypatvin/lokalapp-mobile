import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../models/product_subscription_plan.dart';
import '../../../../providers/users.dart';
import '../../../chat/components/chat_avatar.dart';

class SubscriptionPlanDetails extends StatelessWidget {
  const SubscriptionPlanDetails({
    Key? key,
    this.isBuyer = true,
    this.displayHeader = true,
    required this.subscriptionPlan,
  }) : super(key: key);

  final bool isBuyer;
  final bool displayHeader;
  final ProductSubscriptionPlan subscriptionPlan;

  @override
  Widget build(BuildContext context) {
    final user = context.read<Users>().findById(subscriptionPlan.buyerId)!;
    final name = isBuyer ? subscriptionPlan.shop.name : user.displayName;
    final displayPhoto =
        isBuyer ? subscriptionPlan.shop.image : user.profilePhoto;
    final item = subscriptionPlan.product;
    final disabled = subscriptionPlan.status == SubscriptionStatus.disabled;
    final String _subHeader;
    if (disabled) {
      _subHeader = isBuyer ? 'For Confirmation' : 'To Confirm';
    } else {
      _subHeader = 'Subscription';
    }

    return Column(
      children: [
        if (displayHeader)
          Row(
            children: [
              Expanded(
                child: Text(
                  _subHeader,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
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
              child: CachedNetworkImage(
                imageUrl: item.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                errorWidget: (ctx, url, error) {
                  if (item.image.isNotEmpty) {
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
                item.name,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10.0.w),
            SizedBox(
              width: 50.0.w,
              child: Text(
                'x${subscriptionPlan.quantity}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Text(
              'P ${item.price}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    );
  }
}
