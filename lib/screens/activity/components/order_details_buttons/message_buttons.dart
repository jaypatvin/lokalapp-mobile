import 'package:flutter/material.dart';

import 'package:lokalapp/utils/themes.dart';

import 'order_button.dart';

class MessageBuyerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: ADD MESSAGE BUYER FUNCTION
    return OrderButton("Message Buyer", kTealColor, false, null);
  }
}

class MessageSellerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: ADD MESSAGE SELLER FUNCTION
    return OrderButton("Message Seller", kTealColor, false, null);
  }
}
