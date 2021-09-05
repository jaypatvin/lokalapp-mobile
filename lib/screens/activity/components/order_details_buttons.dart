import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/lokal_images.dart';
import '../../../models/order.dart';
import '../../../providers/user.dart';
import '../../../services/lokal_api_service.dart';
import '../../../utils/functions.utils.dart';
import '../buyer/order_received.dart';
import '../buyer/payment_option.dart';
import '../seller/order_confirmed.dart';
import '../seller/payment_confirmed.dart';
import '../seller/shipped_out.dart';
import 'order_details_buttons/message_buttons.dart';
import 'order_details_buttons/order_actions.dart';
import 'order_details_buttons/status_buttons/status_100.dart';
import 'order_details_buttons/status_buttons/status_200.dart';
import 'order_details_buttons/status_buttons/status_300.dart';
import 'order_details_buttons/status_buttons/status_400.dart';
import 'order_details_buttons/status_buttons/status_500.dart';
import 'order_details_buttons/status_buttons/status_600.dart';

class OrderDetailsButtons extends StatelessWidget {
  final int statusCode;
  final bool isBuyer;
  final Order order;
  const OrderDetailsButtons({
    @required this.statusCode,
    @required this.isBuyer,
    @required this.order,
  });

  // We'll let this stateless widget handle its own button press
  void onPress(BuildContext context, OrderAction action) async {
    final authToken = Provider.of<CurrentUser>(context, listen: false).idToken;

    switch (action) {
      case OrderAction.cancel:
        await LokalApiService.instance.orders.cancel(
          idToken: authToken,
          orderId: this.order.id,
        );
        break;
      case OrderAction.decline:
        await LokalApiService.instance.orders.decline(
          idToken: authToken,
          orderId: this.order.id,
        );
        break;
      case OrderAction.confirm:
        final response = await LokalApiService.instance.orders.confirm(
          idToken: authToken,
          orderId: this.order.id,
        );
        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmed(
                order: this.order,
                isBuyer: this.isBuyer,
              ),
            ),
          ).then((_) => Navigator.pop(context));
        }
        break;
      case OrderAction.pay:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentOption(order: this.order),
          ),
        ).then((_) => Navigator.pop(context));
        break;
      case OrderAction.viewPayment:
        final galleryItems = <LokalImages>[
          LokalImages(url: order.proofOfPayment, order: 0),
        ];
        openGallery(context, 0, galleryItems);
        break;
      case OrderAction.confirmPayment:
        final response = await LokalApiService.instance.orders.confirmPayment(
          idToken: authToken,
          orderId: this.order.id,
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentConfirmed(order: this.order),
            ),
          ).then((_) => Navigator.pop(context));
        }
        break;
      case OrderAction.shipOut:
        final response = await LokalApiService.instance.orders.shipOut(
          idToken: authToken,
          orderId: this.order.id,
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShippedOut(order: this.order),
            ),
          ).then((_) => Navigator.pop(context));
        }
        break;
      case OrderAction.received:
        final response = await LokalApiService.instance.orders.receive(
          idToken: authToken,
          orderId: this.order.id,
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderReceived(order: this.order),
            ),
          ).then((_) => Navigator.pop(context));
        }

        break;
      case OrderAction.orderAgain:
        //TODO: add logic for order again
        break;
    }
  }

  // The buttons are already laid out instead of programatically generating it
  // based on the status code.
  @override
  Widget build(BuildContext context) {
    switch (statusCode) {
      case 100:
        return Status100Buttons(
          isBuyer: this.isBuyer,
          order: this.order,
          onPress: (action) => this.onPress(context, action),
        );
      case 200:
        return Status200Buttons(
          isBuyer: this.isBuyer,
          order: this.order,
          onPress: (action) => this.onPress(context, action),
        );
      case 300:
        return Status300Buttons(
          isBuyer: this.isBuyer,
          order: this.order,
          onPress: (action) => this.onPress(context, action),
          paymentMethod: this.order.paymentMethod,
        );
      case 400:
        return Status400Buttons(
          isBuyer: this.isBuyer,
          order: this.order,
          onPress: (action) => this.onPress(context, action),
          paymentMethod: this.order.paymentMethod,
        );
      case 500:
        return Status500Buttons(
          isBuyer: this.isBuyer,
          order: this.order,
          onPress: (action) => this.onPress(context, action),
          paymentMethod: this.order.paymentMethod,
        );
      case 600:
        return Status600Buttons(
          isBuyer: this.isBuyer,
          order: this.order,
          onPress: (action) => this.onPress(context, action),
          paymentMethod: this.order.paymentMethod,
        );
      default:
        return this.isBuyer
            ? Container(
                width: double.infinity,
                child: MessageSellerButton(order: this.order),
              )
            : Container(
                width: double.infinity,
                child: MessageBuyerButton(order: this.order),
              );
    }
  }
}
