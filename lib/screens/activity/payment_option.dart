import 'package:flutter/material.dart';
import 'package:lokalapp/screens/activity/proof_of_payment.dart';
import 'package:lokalapp/utils/themes.dart';

class PaymentOption extends StatelessWidget {
  appbar(context) => PreferredSize(
      child: Container(
        color: Color(0XFFCC3752),
        height: 60.0,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(context);
                }),
            SizedBox(
              width: 120,
            ),
            Row(
              children: [
                Text(
                  "Order",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "GoldplayBold",
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(60.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: kTealColor,
        bottom: appbar(context),
      ),
      body: ListView(shrinkWrap: true, children: [
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Text(
                "Cash On Delivery",
                style: TextStyle(
                    fontFamily: "GoldplayBold", fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: kTealColor,
                  ),
                  onPressed: () {}),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProofOfPayment()));
              },
              child: ListTile(
                leading: Text(
                  "Bank Deposit",
                  style: TextStyle(
                      fontFamily: "GoldplayBold", fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: kTealColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProofOfPayment()));
                    }),
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            ListTile(
              leading: Text(
                "GCash",
                style: TextStyle(
                    fontFamily: "GoldplayBold", fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: kTealColor,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
      ]),
    );
  }
}
