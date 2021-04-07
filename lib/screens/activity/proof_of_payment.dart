import 'package:flutter/material.dart';
import 'package:lokalapp/screens/activity/paid.dart';
import 'package:lokalapp/utils/themes.dart';

class ProofOfPayment extends StatelessWidget {
  void _goToNewScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Paid()));
  }

  void _goBack(BuildContext context) {
    Navigator.of(context).pop(context);
  }

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
                  _goBack(context);
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

  buildButtons(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(2),
            height: 43,
            width: 250,
            child: FlatButton(
              // height: 50,
              // minWidth: 100,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Color(0XFFCC3752)),
              ),
              textColor: Colors.black,
              child: Text(
                "UPLOAD PROOF OF PAYMENT",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 14,
                    color: Color(0XFFCC3752),
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 43,
            width: 190,
            padding: const EdgeInsets.all(2),
            child: FlatButton(
                // height: 50,
                // minWidth: 100,
                color: kTealColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: kTealColor),
                ),
                textColor: Colors.black,
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  _goToNewScreen(context);
                }),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      );

  buildBody(context) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Bank Deposit",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Goldplay"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Bank",
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "GoldplayBold"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Account Name",
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "GoldplayBold"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Account Number",
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "GoldplayBold"),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Bank",
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "GoldplayBold"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Account Name",
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "GoldplayBold"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Account Number",
              style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "GoldplayBold"),
            ),
            SizedBox(
              height: 80,
              // width: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: buildButtons(context),
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: kTealColor,
          bottom: appbar(context),
        ),
        body: buildBody(context));
  }
}
