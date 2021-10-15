import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../utils/themes.dart';
import 'components/order_details_buttons.dart';
import 'components/transaction_details.dart';

// This Widget will display all states/conditions of the order details to avoid
// code repetition.
class OrderDetails extends StatelessWidget {
  final bool isBuyer;
  final String? subheader;
  final Order order;
  const OrderDetails({
    required this.order,
    this.isBuyer = true,
    this.subheader = "",
  });

  Widget buildTextInfo() {
    final _address = order.deliveryAddress;
    final address = _address.street! +
        ", " +
        _address.barangay! +
        ", " +
        _address.subdivision! +
        " " +
        _address.city!;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            order.instruction!,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            "Delivery Address:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            address,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.0),
          if (order.statusCode! >= 400)
            RichText(
              text: TextSpan(
                text: "Mode of Payment: ",
                children: [
                  TextSpan(
                    text: getModeOfPayment(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Goldplay",
                ),
              ),
            ),
        ],
      ),
    );
  }

  String getModeOfPayment() {
    if (order.paymentMethod == "bank") {
      return "Bank Transfer/Deposit";
    } else if (order.paymentMethod == "cod") {
      return "Cash on Delivery";
    } else {
      return "GCash";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: this.isBuyer ? kTealColor : Color(0xFF57183F),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Order Details",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Colors.white,
              ),
            ),
            Visibility(
              visible: subheader!.isNotEmpty,
              child: Text(
                subheader!,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color:
                      this.order.statusCode == 10 || this.order.statusCode == 20
                          ? kOrangeColor
                          : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 36.0,
          vertical: 24.0,
        ),
        child: Column(
          children: [
            TransactionDetails(
              transaction: order,
              isBuyer: this.isBuyer,
            ),
            SizedBox(height: 16.0),
            buildTextInfo(),
            SizedBox(height: 16.0),
            Spacer(),
            //Text("Mode of Payment: ${getModeOfPayment()}"),
            OrderDetailsButtons(
              statusCode: order.statusCode,
              isBuyer: this.isBuyer,
              order: this.order,
            ),
          ],
        ),
      ),
    );
  }
}
