import 'package:flutter/material.dart';
import 'package:lokalapp/screens/activity/buyer/paid.dart';
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
        padding: const EdgeInsets.only(top: 40),
        height: 100.0,
        decoration: BoxDecoration(color: kTealColor),
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).pop(context);
                }),
            SizedBox(
              width: 40,
            ),
            Row(
              children: [
                Text(
                  "Bank Transfer/ Deposit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(90.0));

  buildButtons(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 25),
            height: 43,
            width: MediaQuery.of(context).size.width * 0.9,
            child: FlatButton(
              // height: 50,
              // minWidth: 100,
              color: kTealColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                // side: BorderSide(color: Color(0XFFCC3752)),
              ),
              textColor: Colors.black,
              child: Text(
                "UPLOAD PROOF OF PAYMENT",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 14,
                    color: Colors.white,
                    // color: Color(0XFFCC3752),
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
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.only(left: 10, right: 25),
            child: FlatButton(
                // height: 50,
                // minWidth: 100,
                color: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  // side: BorderSide(color: kTealColor),
                ),
                textColor: Colors.black,
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontSize: 14,
                      color: Colors.white,
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
            Container(
              margin: const EdgeInsets.only(left: 30, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Please deposit",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "P1,380",
                    style: TextStyle(
                        color: Color(0XFFFF7A00),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Text(
                      "to any of these bank ",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  "accounts:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bank Of The Philippine Islands",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Goldplay"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Account Number:",
                        style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      Text(
                        "0123456789",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Account Name",
                        style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Ida De Jesus",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Unionbank of the Philippines",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Goldplay"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Account Number",
                        style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      ),
                      SizedBox(
                        width: 38,
                      ),
                      Text(
                        "0123456789",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Account Name",
                        style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Ida De Jesus",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "GoldplayBold"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 90,
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
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context), body: buildBody(context));
  }
}
