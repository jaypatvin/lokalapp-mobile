import 'package:flutter/material.dart';
import 'package:lokalapp/models/transaction.dart';
import 'package:lokalapp/screens/activity/to_pay.dart';
import 'package:lokalapp/utils/themes.dart';

import '../order_details.dart';
import '../paid.dart';

import '../for_delivery_buyer.dart';
import '../order_details.dart';
import '../to_pay.dart';


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
  3: 'To Receive'
};

const Map<int, String> sellerActivityState = {
  0: 'Past Order',
  1: 'Waiting for Payment',
  2: 'To Confirm',
  3: 'Payment Received',
  4: 'To Deliver'
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
    if (isBuyer && transactionState == 2) {
      enableSecondButton = true;
      secondButtonText = 'Pay Now';
    } else if (!isBuyer) {
      switch (transactionState) {
        case 2:
          enableSecondButton = true;
          secondButtonText = 'Confirm Order';
          break;
        case 3:
          enableSecondButton = true;
          secondButtonText = 'Confirm Payment';
          break;
        case 4:
          enableSecondButton = true;
          secondButtonText = 'Mark as Delivered';
          break;
        default:
          // do nothing
          break;
      }
    }
    return TransactionCard._(transactionState, date, dealer, transasctions,
        isBuyer, enableSecondButton, secondButtonText);
  }

  void onPress(BuildContext context) {
    // TODO: ADD NAVIGATION FOR SELLER
    if (!isBuyer) return;
    switch (transactionState) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderDetails()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToPay()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForDeliveryBuyer()));
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
            onPressed: () => onPress(context),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ToPay()));
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
                        color: Colors.pink,
                        // TODO: ADD IMAGE FOR PRODUCT
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: NetworkImage(transasctions[index].url),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
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
