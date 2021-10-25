import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../providers/auth.dart';
import '../../../services/lokal_api_service.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/screen_loader.dart';
import 'processing_payment.dart';

class CashOnDelivery extends StatefulWidget {
  final Order order;
  CashOnDelivery({Key? key, required this.order}) : super(key: key);

  @override
  _CashOnDeliveryState createState() => _CashOnDeliveryState();
}

class _CashOnDeliveryState extends State<CashOnDelivery> with ScreenLoader {
  final _termsConditionHandler = TapGestureRecognizer()
    ..onTap = () {
      print("Terms & Conditions tapped");
    };

  FutureOr<void> _onSubmitHandler(BuildContext context) {
    final idToken = context.read<Auth>().idToken;
    LokalApiService.instance!.orders!.pay(
      idToken: idToken,
      orderId: this.widget.order.id,
      data: <String, String>{
        "payment_method": "cod",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // The ProcessingPaymentScreen returns a boolean on successful
        // payment. If it is, we pop this and go back to the Activity screen.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProcessingPayment(
              order: this.widget.order,
              paymentMode: PaymentMode.bank,
            ),
          ),
        ).then((_) => Navigator.pop(context, true));
      }
    });
  }

  @override
  Widget screen(BuildContext context) {
    final numberFormat = NumberFormat("#,###.0#", "en_US");
    final price = this
        .widget
        .order
        .products
        .fold(0.0, (double prev, product) => prev + product.price!);
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Cash on Delivery",
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        leadingColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          SizedBox(height: 36.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Please prepare "),
                  TextSpan(
                    text: "P ${numberFormat.format(price)}",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " for when the courier arrives.")
                ],
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "By completing this order, you agree to all "),
                  TextSpan(
                    text: "Terms & Conditions",
                    recognizer: _termsConditionHandler,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTealColor,
                    ),
                  ),
                ],
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              child: AppButton(
                "Submit",
                kTealColor,
                true,
                () async => await performFuture<void>(
                    () async => await _onSubmitHandler(context)),
                textStyle: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
          SizedBox(height: 24.0)
        ],
      ),
    );
  }
}
