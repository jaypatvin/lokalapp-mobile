import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../providers/auth.dart';
import '../../../services/local_image_service.dart';
import '../../../services/lokal_api_service.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/utility.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/photo_box.dart';
import '../../../widgets/overlays/screen_loader.dart';
import 'processing_payment.dart';

class BankDetails extends StatefulWidget {
  final Order order;
  const BankDetails({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> with ScreenLoader {
  File? proofOfPayment;

  void _imagePickerHandler() async {
    final photo = await MediaUtility.instance!.showMediaDialog(context);

    if (photo != null) {
      setState(() {
        proofOfPayment = photo;
      });
    }
  }

  Future<void> _onSubmitHandler() async {
    final idToken = context.read<Auth>().idToken;
    final service = LocalImageService.instance!;
    final url = await service.uploadImage(
      file: this.proofOfPayment!,
      name: "proof_of_payment",
    );

    LokalApiService.instance!.orders!.pay(
      idToken: idToken,
      orderId: widget.order.id,
      data: <String, String>{
        "payment_method": "bank",
        "proof_of_payment": url,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // The ProcessingPaymentScreen returns a boolean on successful
        // payment. If it is, we pop this and go back to the Activity screen.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProcessingPayment(
              order: widget.order,
              paymentMode: PaymentMode.bank,
            ),
          ),
        ).then((_) => Navigator.pop(context, true));
      }
    });
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Bank Transfer/Deposit",
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        leadingColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          // TODO: add bank details
          Text("Put bank details here in the future"),
          SizedBox(height: 16.0),
          if (proofOfPayment != null)
            PhotoBox(
              shape: BoxShape.rectangle,
              file: proofOfPayment,
              displayBorder: false,
            ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              child: AppButton(
                "${proofOfPayment != null ? 'Re-u' : 'U'}pload proof of payment",
                kTealColor,
                proofOfPayment != null ? false : true,
                _imagePickerHandler,
                textStyle: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              child: AppButton(
                "Submit",
                proofOfPayment != null ? kTealColor : Colors.grey,
                true,
                proofOfPayment != null
                    ? () async => await performFuture<void>(
                        () async => await _onSubmitHandler())
                    : null,
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
