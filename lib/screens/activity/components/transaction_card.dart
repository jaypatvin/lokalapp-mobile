import 'package:flutter/material.dart';
import 'package:lokalapp/models/transaction.dart';
import '../buyer/declined_order_a7.dart';
import '../seller/past_order_delivered_b6.dart';
import '../seller/payment_confirmed_b3.dart';
import '../seller/shipped_out_b5.dart';
import '../seller/to_ship_b4.dart';
import 'package:lokalapp/utils/themes.dart';
import '../../../models/transaction.dart';
import '../../../utils/themes.dart';
import '../buyer/for_confirmation_a3.dart';
import '../buyer/for_delivery_buyer_a4.dart';
import '../buyer/for_delivery_confirmed_a5.dart';
import '../buyer/order_recieved_a5.dart';
import '../buyer/payment_option.dart';
import '../buyer/to_pay.dart';
import '../seller/confirm_payment_b3.dart';
import '../seller/order_confimred_b1.dart';
import '../seller/order_details_b1.dart';
import '../seller/waiting_for_payment_b2.dart';

// THIS IS A MOCK DATA FOR BUILD PURPOSES
List<Transaction> transactions = [
  Transaction(
    productName: 'Chocolate Cake',
    quantity: 1,
    price: 420,
  ),
  Transaction(
    productName: 'Strawberry Cake',
    quantity: 2,
    price: 420,
  )
];

const Map<int, String> buyerActivityState = {
  0: 'Past Order',
  1: 'For Seller\'s Confirmation',
  2: 'To Pay',
  3: 'Waiting for Delivery',
  4: 'To Receive'
};

const Map<int, String> sellerActivityState = {
  0: 'Past Order',
  1: 'To Confirm',
  2: 'Waiting for Payment',
  3: 'Payment Received',
  4: 'To Ship',
  5: 'Shipped Out',
  6: 'Declined Order'
};

class TransactionCard extends StatelessWidget {
  final int transactionState;
  final String date;
  final String dealer;
  final List<Transaction> transasctions;
  final bool isBuyer;

  final bool enableSecondButton;
  final secondButtonText;

  TransactionCard._(
      this.transactionState,
      this.date,
      this.dealer,
      this.transasctions,
      this.isBuyer,
      this.enableSecondButton,
      this.secondButtonText);

  factory TransactionCard({
    @required transactionState,
    @required date,
    @required dealer,
    @required transasctions,
    @required isBuyer,
  }) {
    bool enableSecondButton = false;
    String secondButtonText = '';
    if (isBuyer) {
      switch (transactionState) {
        case 2:
          enableSecondButton = true;
          secondButtonText = 'Pay Now';
          break;
        case 4:
          enableSecondButton = true;
          secondButtonText = 'Order Received';
          break;
        default:
          //do nothing
          break;
      }
    } else if (!isBuyer) {
      switch (transactionState) {
        case 1:
          enableSecondButton = true;
          secondButtonText = 'Confirm Order';
          break;
        case 3:
          enableSecondButton = true;
          secondButtonText = 'Confirm Payment';
          break;
        case 4:
          enableSecondButton = true;
          secondButtonText = 'Ship Out';
          break;
        default:
          // do nothing
          break;
      }
    }
    return TransactionCard._(transactionState, date, dealer, transasctions,
        isBuyer, enableSecondButton, secondButtonText);
  }

  void onSecondButtonPress(BuildContext context) {
    if (isBuyer) {
      switch (transactionState) {
        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentOption()));
          break;
        case 4:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderRecieved()));
          break;
        default:
          break;
      }
    } else {
      switch (transactionState) {
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderConfirmed()));
          break;
        case 3:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ConfirmPaymentSeller()));
          break;
        case 4:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentConfirmedSeller()));
          break;
        default:
          // do nothing
          break;
      }
    }
  }

  void onPress(BuildContext context) {
    // TODO: ADD NAVIGATION FOR SELLER
    if (!isBuyer) return;
    switch (transactionState) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForConfirmation()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToPay()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForDeliveryBuyer()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForDeliveryConfirmed()));
        break;
      default:
        // do nothing
        break;
    }
  }

  void onPressedSeller(BuildContext context) {
    if (isBuyer) return;
    switch (transactionState) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PastOrderDelivered()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WaitingForPayment()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderDetailsSeller()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConfirmPaymentSeller()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToShipSeller()));
        break;
      case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShippedOut()));
        break;
      case 6:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DeclinedOrder()));
        break;
      default:
        // do nothing
        break;
    }
  }

  Widget buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FlatButton(
              height: MediaQuery.of(context).size.height * 0.05,
              color: Color(0xFFF1FAFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: kTealColor,
              child: Text(
                "DETAILS",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () =>
                  isBuyer ? onPress(context) : onPressedSeller(context)),
        ),
        Visibility(
          visible: enableSecondButton,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
        Visibility(
          visible: enableSecondButton,
          child: Expanded(
            child: FlatButton(
              height: MediaQuery.of(context).size.height * 0.05,
              color: Color(0XFFFF7A00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textColor: kTealColor,
              child: Text(
                secondButtonText,
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                onSecondButtonPress(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    transactions.forEach((item) {
      total += item.quantity * item.price;
    });
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Color(0xFFF1FAFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isBuyer
                      ? buyerActivityState[transactionState]
                      : sellerActivityState[transactionState],
                ),
                Text('For $date'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              children: [
                // TODO: ADD PROFILE PICTURE
                CircleAvatar(
                  minRadius: MediaQuery.of(context).size.width * 0.05,
                  backgroundColor: Colors.pink,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Text(dealer),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: transasctions.length,
              itemBuilder: (ctx, index) {
                var item = transactions[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.12,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.living-lifestyle.co.za%2Fwp-content%2Fuploads%2F2016%2F06%2Fmoltenpeanutbutterchocolatefondantcake6x4.jpg&f=1&nofb=1"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(item.productName),
                      Text('x${item.quantity}'),
                      Text('P ${item.quantity * item.price}'),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Divider(
              color: Colors.grey,
              indent: 0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Order Total P$total'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}
