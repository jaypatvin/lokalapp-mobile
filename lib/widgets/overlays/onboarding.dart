import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/assets.dart';
import '../../utils/constants/descriptions.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../app_button.dart';

class Onboarding extends StatefulWidget {
  final Widget child;
  final MainScreen screen;
  const Onboarding({
    Key? key,
    required this.screen,
    required this.child,
  }) : super(key: key);

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
  Future<void> afterFirstLayout(BuildContext context) async {
    final _prefs = context.read<UserSharedPreferences>();
    if (!_prefs.getOnboardingStatus(widget.screen)) {
      if (mounted) setState(() => _displayOnboarding = true);
    }
  }

  Widget _buildOnboardingCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
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
                    color: kPinkColor,
                    height: 60,
                  ),
                  Text(
                    _onboardDetails[widget.screen]!['title']!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: kPinkColor,
                        ),
                  )
                ],
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Text(
                  _onboardDetails[widget.screen]!['description']!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          AppButton.filled(
            text: _onboardDetails[widget.screen]!['label'] ?? '',
            onPressed: () async {
              setState(() {
                _displayOnboarding = false;
              });
              await context
                  .read<UserSharedPreferences>()
                  .updateOnboardingStatus(widget.screen);
              final _tabController = context.read<PersistentTabController>();
              if (_tabController.index == 4) return;
              _tabController.index++;
            },
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
                  padding: const EdgeInsets.all(16.0),
                  child: _buildOnboardingCard(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
