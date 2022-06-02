import 'package:flutter/material.dart';

import '../../routers/app_router.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/app_button.dart';
import 'home.dart';

class ReportSent extends StatelessWidget {
  const ReportSent({Key? key}) : super(key: key);

  void _onBackToFeed() {
    AppRouter.homeNavigatorKey.currentState?.popUntil(
      ModalRoute.withName(Home.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: AppBar(
        backgroundColor: kInviteScreenColor,
        elevation: 0,
        actions: [
          InkWell(
            onTap: _onBackToFeed,
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
      body: Column(
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
              'Report Sent!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: kTealColor),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: Text(
              'We appreciate your effort in making our community better. '
              "We'll notify you of the progress of your report!",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 91),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: SizedBox(
              width: double.infinity,
              child: AppButton.filled(
                text: 'BACK TO MY FEED',
                onPressed: _onBackToFeed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
