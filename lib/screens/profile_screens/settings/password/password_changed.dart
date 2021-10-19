import 'package:flutter/material.dart';
import '../settings.dart';
import '../../../../utils/constants/themes.dart';

class PasswordChanged extends StatelessWidget {
  buildButton(context) => Container(
        height: 43,
        width: 300,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: kTealColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: kTealColor),
          ),
          textColor: Colors.black,
          child: Text(
            "Back to Settings ",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
                (route) => false);
          },
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 90,
            ),
            Text(
              "Password Changed!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "GoldplayBold",
                  fontWeight: FontWeight.w700,
                  fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 140.0,
              width: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.pngio.com%2Fchange-decryption-encrypt-encryption-limitation-login-png-restrictions-512_512.png&f=1&nofb=1'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Align(
                alignment: Alignment.bottomCenter, child: buildButton(context))
          ],
        ),
      ),
    );
  }
}
