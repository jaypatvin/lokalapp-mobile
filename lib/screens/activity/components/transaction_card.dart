import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/order.dart';
import '../../../utils/themes.dart';
import '../../../widgets/app_button.dart';
import '../order_details.dart';
import 'transaction_details.dart';

class TransactionCard extends StatelessWidget {
  final Order order;
  final bool enableSecondButton;
  final String secondButtonText;
  final double price;
  final String status;
  final bool isBuyer;
  final void Function() onSecondButtonPress;

  const TransactionCard._(
    this.order,
    this.enableSecondButton,
    this.secondButtonText,
    this.price,
    this.status,
    this.isBuyer,
    this.onSecondButtonPress,
  );

  // We'll let this Stateless Widget handle the generation of
  // its second button. If performance is an issue, we can probably
  // lift it one state up.
  factory TransactionCard({
    Order order,
    String status,
    bool isBuyer = false,
    void Function() onSecondButtonPress,
  }) {
    bool enableSecondButton = false;
    String secondButtonText = '';

    switch (order.statusCode) {
      case 10:
      case 20:
        enableSecondButton = true;
        secondButtonText = "Message " + (isBuyer ? "Seller" : "Buyer");
        break;
      case 100:
        enableSecondButton = !isBuyer;
        secondButtonText = "Confirm Order";
        break;
      case 200:
        enableSecondButton = isBuyer;
        secondButtonText = "Pay Now";
        break;
      case 300:
        enableSecondButton = !isBuyer;
        secondButtonText = "Confirm Payment";
        break;
      case 400:
        enableSecondButton = !isBuyer;
        secondButtonText = "Ship Out";
        break;
      case 500:
        enableSecondButton = isBuyer;
        secondButtonText = "Order Received";
        break;
      case 600:
        enableSecondButton = true;
        secondButtonText = isBuyer ? "Order Again" : "Delivered";
        break;
      default:
        break;
    }

    double price = 0;
    order.products.forEach((product) {
      price += (product.productPrice * product.quantity);
    });

    return TransactionCard._(
      order,
      enableSecondButton,
      secondButtonText,
      price,
      status,
      isBuyer,
      onSecondButtonPress,
    );
  }

  Widget buildActionButtons(BuildContext context) {
    var secondButtonColor = kOrangeColor;
    if (order.statusCode == 10 || order.statusCode == 20) {
      secondButtonColor = kTealColor;
    } else if (order.statusCode == 600) {
      secondButtonColor = Colors.grey;
    }

    final disabled = order.statusCode == 600 && !isBuyer;
    final isFilled = (order.statusCode != 10) && (order.statusCode != 20);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton(
          "Details",
          kTealColor,
          false,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetails(
                order: this.order,
                isBuyer: this.isBuyer,
                subheader: this.status,
              ),
            ),
          ),
        ),
        Visibility(
          visible: enableSecondButton,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
        Visibility(
          visible: enableSecondButton,
          child: AppButton(
            secondButtonText,
            secondButtonColor,
            isFilled,
            disabled ? null : onSecondButtonPress,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: (order.statusCode == 10 || order.statusCode == 20)
            ? BorderSide(color: Colors.red)
            : BorderSide.none,
      ),
      color: Color(0xFFF1FAFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            TransactionDetails(
              status: this.status,
              transaction: this.order,
              isBuyer: this.isBuyer,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}
