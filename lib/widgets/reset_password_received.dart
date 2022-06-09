import 'package:flutter/material.dart';

import '../../utils/constants/themes.dart';

class ResetPasswordReceived extends StatelessWidget {
  const ResetPasswordReceived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: AppBar(
        backgroundColor: kInviteScreenColor,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Done',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: kTealColor),
                ),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 150,
              color: Color(0xFFFFC700),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                'Request received!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              child: Text(
                'Check your email for further instructions on how to reset your '
                'password.',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
