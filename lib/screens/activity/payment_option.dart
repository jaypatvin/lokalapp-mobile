import 'package:flutter/material.dart';
import 'package:lokalapp/screens/activity/proof_of_payment.dart';
import 'package:lokalapp/utils/themes.dart';

class PaymentOption extends StatelessWidget {
  appbar(context) => PreferredSize(
      child: Container(
        padding: const EdgeInsets.only(top: 40),
        height: 90.0,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: kTealColor,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).pop(context);
                }),
            SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Text(
                  "Choose a Payment Option",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(80.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0XFFE5E5E5),
      appBar: appbar(context),
      body: ListView(shrinkWrap: true, children: [
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0XFFF1FAFF),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Ink(
                color: Color(0XFFF1FAFF),
                child: ListTile(
                  title: Text(
                    "Cash On Delivery",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: kTealColor,
                        size: 18,
                      ),
                      onPressed: () {}),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0XFFF1FAFF),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Ink(
                color: Color(0XFFF1FAFF),
                child: ListTile(
                  title: Text(
                    "Bank Transfer/Deposit",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: kTealColor,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProofOfPayment()));
                      }),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0XFFF1FAFF),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Ink(
                color: Color(0XFFF1FAFF),
                child: ListTile(
                  title: Text(
                    "Gcash",
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: kTealColor,
                        size: 18,
                      ),
                      onPressed: () {}),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
