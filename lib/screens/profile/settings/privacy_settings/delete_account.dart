import 'package:flutter/material.dart';

import '../../../../utils/constants/themes.dart';
import '../components/appbar.dart';
import 'account_deleted.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  buildButton(context, text, {bool isTeal = false, Function? onPressed}) =>
      Container(
        height: 43,
        width: 300,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: isTeal ? kTealColor : Color(0XFFCC3752),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: isTeal ? kTealColor : Color(0XFFCC3752)),
          ),
          textColor: Colors.black,
          child: Text(
            text,
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          onPressed: onPressed as void Function()?,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: AppBarSettings(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Delete Account",
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Are you sure you want to delete your account?",
                  style: TextStyle(
                      fontFamily: "GoldplayBold",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Text(
                  "Deleting your account means deleting all of your information, posts, your shop, and history.",
                  style: TextStyle(
                    fontFamily: "GoldplayBold",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Text(
                  "You will not be able to delete your account if you still have confirmed and paid orders that has not yet been delivered.",
                  style: TextStyle(
                    fontFamily: "GoldplayBold",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildButton(context, "Delete Account", isTeal: false,
                onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountDeleted()));
            }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            buildButton(context, "Go back to settings",
                isTeal: true, onPressed: () {})
          ],
        ),
      ),
    );
  }
}
