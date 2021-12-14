import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/order_received.vm.dart';
import '../../../widgets/app_button.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class OrderReceived extends StatelessWidget {
  final Order order;
  const OrderReceived({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _OrderReceivedView(),
      viewModel: OrderReceivedViewModel(order),
    );
  }
}

class _OrderReceivedView extends StatelessView<OrderReceivedViewModel> {
  @override
  Widget render(BuildContext context, OrderReceivedViewModel vm) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0.h),
              Text(
                'Order Received!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.0.h),
              Container(
                height: 100.0.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        kSvgBackgroundHouses,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Lottie.asset(
                        kAnimationOk,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.0.w),
                child: TransactionDetails(
                  transaction: vm.order,
                  isBuyer: true,
                ),
              ),
              SizedBox(height: 16.0.h),
              !vm.ratingSubmitted
                  ? Column(
                      children: [
                        Text(
                          'Rate your experience',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: vm.onRatingUpdate,
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: _RatingMessage(
                        assetName: vm.assetName,
                        ratingTitle: vm.ratingTitle,
                        ratingMessage: vm.ratingMessage,
                      ),
                    ),
              SizedBox(height: 16.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: MessageSellerButton(order: vm.order),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        "Back to Activity",
                        kTealColor,
                        true,
                        vm.onBackToActivity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingMessage extends StatelessWidget {
  const _RatingMessage({
    Key? key,
    required this.assetName,
    required this.ratingTitle,
    required this.ratingMessage,
  }) : super(key: key);
  final String assetName;
  final String ratingTitle;
  final String ratingMessage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(assetName),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ratingTitle, style: Theme.of(context).textTheme.headline6),
              Text(ratingMessage, style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }
}
