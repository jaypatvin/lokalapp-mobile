import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lokalapp/view_models/activity/order_received.vm.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../components/order_details_buttons/message_buttons.dart';
import '../components/transaction_details.dart';

class OrderReceived extends StatelessWidget {
  final Order order;
  const OrderReceived({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<OrderReceivedViewModel>(
          create: (ctx) => OrderReceivedViewModel(ctx, order),
          builder: (_, __) {
            return Consumer<OrderReceivedViewModel>(
              builder: (ctx, vm, _) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Order Received!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoldplayBold",
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 140.0,
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
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TransactionDetails(
                            transaction: this.order,
                            isBuyer: true,
                          ),
                        ),
                        const SizedBox(height: 16.0),
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
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
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
                        SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: MessageSellerButton(order: order),
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
                );
              },
            );
          },
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
