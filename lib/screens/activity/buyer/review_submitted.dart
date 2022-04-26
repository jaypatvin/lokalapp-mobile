import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';

class ReviewSubmitted extends StatelessWidget {
  const ReviewSubmitted({Key? key}) : super(key: key);

  // TODO: move to ViewModel
  void _onBackToActivity() {
    locator<AppRouter>().popUntil(
      AppRoute.activity,
      predicate: ModalRoute.withName(ActivityRoutes.activity),
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
            onTap: _onBackToActivity,
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
              'Review Submitted!',
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
              'Thank you for taking the time to leave a review!',
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
                text: 'BACK TO MY ACTIVITY',
                onPressed: _onBackToActivity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
