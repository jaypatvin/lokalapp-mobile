import 'package:flutter/material.dart';
import 'package:lokalapp/models/transaction.dart';
import 'package:lokalapp/screens/activity/to_pay.dart';
import 'package:lokalapp/utils/themes.dart';

import '../order_details.dart';
import '../paid.dart';

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

class TransactionCard extends StatelessWidget {
  final String transactionState;
  final String date;
  final String dealer;
  final List<Transaction> transasctions;
  final bool enableOtherButton;
  final String otherButtonText;

  Widget buildActionButtons(BuildContext context) {
    //TODO: REFACTOR REUSED BUTTON WITH DIFFERENT DESIGNS
    if (enableOtherButton) {
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
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Expanded(
            child: FlatButton(
              height: MediaQuery.of(context).size.height * 0.05,
              color: Color(0XFFFF7A00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textColor: kTealColor,
              child: Text(
                otherButtonText,
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
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.80,
        child: FlatButton(
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
          onPressed: () {},
        ),
      );
    }
  }

  TransactionCard({
    @required this.transactionState,
    @required this.date,
    @required this.dealer,
    @required this.transasctions,
    this.enableOtherButton = false,
    this.otherButtonText,
  });
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
                Text(transactionState),
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
