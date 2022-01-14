import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _setScreen();
    context.read<PersistentTabController>().addListener(_setScreen);
  }

  @override
  void dispose() {
    context.read<PersistentTabController>().removeListener(_setScreen);
    super.dispose();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    final _prefs = context.read<UserSharedPreferences>();
    if (!_prefs.getOnboardingStatus(_screen)) {
      if (mounted) setState(() => _displayOnboarding = true);
    }
  }

  void _setScreen() {
    final _tabController = context.read<PersistentTabController>();
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

    final _prefs = context.read<UserSharedPreferences>();
    if (!_prefs.getOnboardingStatus(_screen)) {
      if (mounted) setState(() => _displayOnboarding = true);
    }
  }

  Widget _buildOnboardingCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 20.0.h),
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
                    _onboardDetails[_screen]!['icon']!,
                    color: kPinkColor,
                    height: 75.0.h,
                  ),
                  Text(
                    _onboardDetails[_screen]!['title']!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: kPinkColor,
                        ),
                  )
                ],
              ),
              SizedBox(width: 20.0.w),
              Expanded(
                child: Text(
                  _onboardDetails[_screen]!['description']!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child:
                AppButton(_onboardDetails[_screen]!['label'], kTealColor, true,
                    //() => Navigator.pop(ctx),
                    () async {
              setState(() {
                _displayOnboarding = false;
              });
              await context
                  .read<UserSharedPreferences>()
                  .updateOnboardingStatus(_screen);
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