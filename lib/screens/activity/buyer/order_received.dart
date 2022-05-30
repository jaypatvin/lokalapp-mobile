import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../view_models/activity/order_received.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
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
        child: ConstrainedScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Order Received!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 175,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        kSvgBackgroundHouses,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Lottie.asset(
                          kAnimationOk,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37),
                child: TransactionDetails(
                  transaction: vm.order,
                  isBuyer: true,
                ),
              ),
              const SizedBox(height: 24),
              if (!vm.ratingSubmitted)
                Column(
                  children: [
                    Text('Rate your experience',
                        style: Theme.of(context).textTheme.subtitle2,),
                    RatingBar.builder(
                      minRating: 1,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 6),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: vm.onRatingUpdate,
                    ),
                  ],
                ),
              if (vm.ratingSubmitted)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 37.0,
                  ),
                  child: _RatingMessage(
                    assetName: vm.assetName,
                    ratingTitle: vm.ratingTitle,
                    ratingMessage: vm.ratingMessage,
                  ),
                ),
              const SizedBox(height: 32),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: MessageSellerButton(order: vm.order),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.filled(
                        text: 'Back to Activity',
                        onPressed: vm.onBackToActivity,
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(assetName),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ratingTitle,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Colors.black),
              ),
              Text(
                ratingMessage,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
