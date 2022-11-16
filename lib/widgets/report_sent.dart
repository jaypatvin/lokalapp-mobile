import 'package:flutter/material.dart';

import '../utils/constants/themes.dart';
import 'app_button.dart';
import 'overlays/constrained_scrollview.dart';

class ReportSent extends StatelessWidget {
  const ReportSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: AppBar(
        backgroundColor: kInviteScreenColor,
        elevation: 0,
        actions: [
          InkWell(
            onTap: Navigator.of(context).pop,
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
      body: ConstrainedScrollView(
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
            // const SizedBox(height: 91),
            const SizedBox(height: 24),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  text: 'GO BACK',
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
