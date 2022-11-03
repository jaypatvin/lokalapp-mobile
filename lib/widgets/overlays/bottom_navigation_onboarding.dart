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

/// An alternate to `Onboarding` where the widget lies on top of the
/// `BottomNavigationBar`.
class BottomNavigationOnboarding extends StatefulWidget {
  const BottomNavigationOnboarding({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _BottomNavigationOnboardingState createState() =>
      _BottomNavigationOnboardingState();
}

class _BottomNavigationOnboardingState extends State<BottomNavigationOnboarding>
    with AfterLayoutMixin {
  late final PersistentTabController _tabController;
  late MainScreen _screen;
  bool _displayOnboarding = false;

  final _onboardDetails = <MainScreen, Map<String, String>>{
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

  @override
  void initState() {
    super.initState();
    _tabController = context.read<PersistentTabController>();
    _setScreen();
    _tabController.addListener(_setScreen);
  }

  @override
  void dispose() {
    _tabController.removeListener(_setScreen);
    super.dispose();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    final prefs = context.read<UserSharedPreferences>();
    if (!prefs.getOnboardingStatus(_screen)) {
      if (mounted) setState(() => _displayOnboarding = true);
    }
  }

  void _setScreen() {
    switch (_tabController.index) {
      case 1:
        _screen = MainScreen.discover;
        break;
      case 2:
        _screen = MainScreen.chats;
        break;
      case 3:
        _screen = MainScreen.activity;
        break;
      case 4:
        _screen = MainScreen.profile;
        break;
      default:
        _screen = MainScreen.home;
        break;
    }

    final prefs = context.read<UserSharedPreferences>();
    if (!prefs.getOnboardingStatus(_screen)) {
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
                    _onboardDetails[_screen]!['icon']!,
                    color: kPinkColor,
                    height: 60,
                  ),
                  Text(
                    _onboardDetails[_screen]!['title']!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: kPinkColor,
                        ),
                  )
                ],
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Text(
                  _onboardDetails[_screen]!['description']!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          AppButton.filled(
            text: _onboardDetails[_screen]!['label'] ?? '',
            onPressed: () async {
              setState(() {
                _displayOnboarding = false;
              });
              await context
                  .read<UserSharedPreferences>()
                  .updateOnboardingStatus(_screen);
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
    final mediaQueryData = MediaQuery.of(context);
    final mediaSize = mediaQueryData.size;
    return Stack(
      children: [
        widget.child,
        if (_displayOnboarding)
          SizedBox(
            width: mediaSize.width,
            height: mediaSize.height -
                kBottomNavigationBarHeight -
                mediaQueryData.padding.bottom,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        if (_displayOnboarding)
          SizedBox.expand(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.transparent,
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
