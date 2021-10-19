import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../utils/constants/assets.dart';
import '../utils/constants/descriptions.dart';
import '../utils/constants/themes.dart';
import '../utils/shared_preference.dart';
import 'app_button.dart';

class Onboarding extends StatefulWidget {
  final Widget child;
  final MainScreen screen;
  const Onboarding({required this.screen, required this.child});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with AfterLayoutMixin {
  static const _onboardDetails = <MainScreen, Map<String, String>>{
    MainScreen.home: {
      'icon': kBottomIconHome,
      'title': 'Home',
      'description': kDescriptionHome,
      'label': 'Okay!'
    },
    MainScreen.discover: {
      'icon': kBottomIconDiscover,
      'title': 'Discover',
      'description': kDescriptionDiscover,
      'label': 'Got it!'
    },
    MainScreen.chats: {
      'icon': kBottomIconChat,
      'title': 'Chats',
      'description': kDescriptionChat,
      'label': 'Gotcha!'
    },
    MainScreen.activity: {
      'icon': kBottomIconActivity,
      'title': 'Activity',
      'description': kDescriptionActivity,
      'label': 'Okay!'
    },
    MainScreen.profile: {
      'icon': kBottomIconProfile,
      'title': 'Profile',
      'description': kDescriptionProfile,
      'label': 'Okay!'
    },
  };

  bool _displayOnboarding = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    final _prefs = context.read<UserSharedPreferences>();
    if (!_prefs.getOnboardingStatus(widget.screen)) {
      // await _showAlert();
      // await _prefs.updateStatus(widget.screen);
      if (this.mounted) setState(() => _displayOnboarding = true);
    }
  }

  Widget _buildOnboardingCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 10.0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    _onboardDetails[widget.screen]!['icon']!,
                    fit: BoxFit.contain,
                    color: kPinkColor,
                    height: 75.0.h,
                  ),
                  Text(
                    _onboardDetails[widget.screen]!['title']!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: kPinkColor,
                        ),
                  )
                ],
              ),
              SizedBox(width: 20.0.w),
              Expanded(
                child: Text(
                  _onboardDetails[widget.screen]!['description']!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: AppButton(
                _onboardDetails[widget.screen]!['label']!, kTealColor, true,
                //() => Navigator.pop(ctx),
                () async {
              setState(() {
                _displayOnboarding = false;
              });
              await context
                  .read<UserSharedPreferences>()
                  .updateOnboardingStatus(widget.screen);
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_displayOnboarding)
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildOnboardingCard(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
