import 'dart:io' show File, Platform;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/failure_exception.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../screens/bottom_navigation.dart';
import '../../services/api/api.dart';
import '../../services/api/user_api_service.dart';
import '../../services/local_image_service.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../utils/media_utility.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../overlays/constrained_scrollview.dart';
import '../overlays/screen_loader.dart';
import '../photo_box.dart';
import 'verify_confirmation_screen.dart';

class VerifyScreen extends StatefulWidget {
  final bool skippable;
  const VerifyScreen({
    Key? key,
    this.skippable = true,
  }) : super(key: key);
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with ScreenLoader {
  final _ids = const <String>[
    "Driver's License",
    'Old Philippine Passport (Issued before 15 Aug 2016)',
    'New Philippine Passport',
    'Unified Multipurpose ID',
  ];

  String? _chosenIdType;
  File? _file;
  String? _uploadedImage;

  @override
  void initState() {
    super.initState();

    final user = context.read<Auth>().user;

    _chosenIdType = user?.registration?.idType?.isNotEmpty ?? false
        ? user?.registration?.idType
        : null;
    _uploadedImage = user?.registration?.idPhoto;
  }

  Widget _androidDropDown() {
    final List<DropdownMenuItem<String>> dropDownItems = [];

    for (final id in _ids) {
      dropDownItems.add(
        DropdownMenuItem(
          value: id,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: const Text(
            'Select type of ID',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        value: _chosenIdType,
        isExpanded: true,
        items: dropDownItems,
        focusColor: Colors.white,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: kTealColor,
        ),
        iconSize: 24.0.sp,
        onChanged: (value) {
          setState(() => _chosenIdType = value);
        },
      ),
    );
  }

  Widget _iOSPicker() {
    final pickerItems = _ids
        .map<Widget>(
          (id) => Center(
            child: Text(
              id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();

    return CupertinoButton(
      child: Row(
        children: [
          if (_chosenIdType == null)
            Expanded(
              child: Text(
                'Select type of ID',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.grey,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (_chosenIdType != null)
            Expanded(
              child: Text(
                _chosenIdType!,
                style: Theme.of(context).textTheme.bodyText2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const Icon(
            Icons.arrow_drop_down,
            color: kTealColor,
          ),
        ],
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return SizedBox(
              height: 200.h,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    textStyle: Theme.of(context).textTheme.bodyText2,
                    actionTextStyle: Theme.of(context).textTheme.bodyText2,
                    pickerTextStyle:
                        Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.black,
                              fontSize: 18.0.sp,
                            ),
                  ),
                ),
                child: CupertinoPicker(
                  itemExtent: 32.0.h,
                  onSelectedItemChanged: (selectedIndex) {
                    setState(() => _chosenIdType = _ids[selectedIndex]);
                  },
                  children: pickerItems,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSubmitHandler() async {
    if (_file == null) {
      showToast(
        'Please select an image.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (_chosenIdType == null) {
      showToast(
        'Please select an ID type.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final user = context.read<Auth>().user!;
    try {
      final picker = context.read<LocalImageService>();
      final mediaUrl = await picker.uploadImage(
        file: _file!,
        src: kVerificationImagesSrc,
      );

      if (mediaUrl.isEmpty) {
        throw FailureException('Error uploading image. Try again.');
      }

      final success = await UserAPIService(context.read<API>()).registerUser(
        userId: user.id!,
        body: {
          'id_type': _chosenIdType!,
          'id_photo': mediaUrl,
        },
      );

      if (success) {
        if (widget.skippable) {
          AppRouter.rootNavigatorKey.currentState?.pushAndRemoveUntil(
            AppNavigator.appPageRoute(
              builder: (_) => VerifyConfirmationScreen(
                skippable: widget.skippable,
              ),
            ),
            (route) => false,
          );
        } else {
          AppRouter.profileNavigatorKey.currentState?.pushReplacement(
            AppNavigator.appPageRoute(
              builder: (_) => VerifyConfirmationScreen(
                skippable: widget.skippable,
              ),
            ),
          );
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  List<Widget>? _appBarActions() {
    if (widget.skippable) {
      return [
        TextButton(
          onPressed: () {
            AppRouter.rootNavigatorKey.currentState?.push(
              AppNavigator.appPageRoute(
                builder: (_) => const BottomNavigation(),
              ),
            );
          },
          child: Text(
            'Skip',
            style: TextStyle(
              color: kTealColor,
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ];
    }

    return null;
  }

  Future<bool> _onWillPop() async {
    if (widget.skippable) {
      AppRouter.rootNavigatorKey.currentState?.push(
        AppNavigator.appPageRoute(
          builder: (_) => const BottomNavigation(),
        ),
      );
    }
    return true;
  }

  @override
  Widget screen(BuildContext context) {
    return NestedWillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        appBar: CustomAppBar(
          leadingColor: kTealColor,
          backgroundColor: kInviteScreenColor,
          onPressedLeading: () => Navigator.maybePop(context),
          actions: _appBarActions(),
        ),
        body: ConstrainedScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verify Your Account',
                  style: TextStyle(
                    fontSize: 30.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0.h),
                const Text(
                  "In order to access all of Lokal's features, "
                  'we need to verify your identity',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: kNavyColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.0.h),
                Container(
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                  child: Platform.isIOS ? _iOSPicker() : _androidDropDown(),
                ),
                SizedBox(height: 20.0.h),
                PhotoBox(
                  shape: BoxShape.rectangle,
                  width: 200.w,
                  height: 150.h,
                  displayBorder: false,
                  displayIcon: false,
                  imageSource: PhotoBoxImageSource(
                    file: _file,
                    url: _uploadedImage,
                  ),
                ),
                SizedBox(height: 10.0.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.transparent(
                    text: _file != null || (_uploadedImage?.isNotEmpty ?? false)
                        ? 'Choose a different photo'
                        : 'UPLOAD PHOTO OF ID',
                    onPressed: () async {
                      _file = await context
                              .read<MediaUtility>()
                              .showMediaDialog(context) ??
                          _file;
                      setState(() {});
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 160.0.w,
                  child: AppButton.filled(
                    text: 'SUBMIT',
                    onPressed: _file != null
                        ? () async {
                            await performFuture<void>(_onSubmitHandler);
                          }
                        : null,
                    textStyle: _file != null
                        ? const TextStyle(
                            color: kNavyColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
