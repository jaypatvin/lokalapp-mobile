import 'dart:io' show File, Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/models/nested_will_pop_scope.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../services/api/api.dart';
import '../../services/api/user_api_service.dart';
import '../../services/local_image_service.dart';
import '../../utils/constants/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../bottom_navigation.dart';
import 'verify_confirmation_screen.dart';

class VerifyScreen extends StatefulWidget {
  final bool skippable;
  const VerifyScreen({Key? key, this.skippable = true}) : super(key: key);
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _ids = <String>[
    "Driver's License",
    "Old Philippine Passport (Issued before 15 Aug 2016)",
    "New Philippine Passport",
    "Unified Multipurpose ID",
  ];

  String? _chosenIdType;
  File? _file;

  Widget androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (var id in _ids) {
      dropDownItems.add(
        DropdownMenuItem(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          value: id,
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Text(
            "Select type of ID",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        value: _chosenIdType,
        isExpanded: true,
        items: dropDownItems,
        focusColor: Colors.white,
        icon: Icon(
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

  Widget iOSPicker() {
    List<Widget> pickerItems = [];

    for (var id in _ids) {
      pickerItems.add(
        Center(
          child: Text(
            id,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          pickerTextStyle: TextStyle(
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
    );
  }

  void _onSubmitHandler() async {
    LocalImageService picker =
        Provider.of<LocalImageService>(context, listen: false);
    if (_file != null) {
      String mediaUrl =
          await picker.uploadImage(file: _file!, name: 'verification');

      if (mediaUrl.isNotEmpty) {
        // TODO: CHANGE TO PROVIDER
        final user = context.read<Auth>().user!;
        try {
          final verified = await UserAPIService(context.read<API>()).update(
            body: {
              'id': user.id!,
              'id_photo': mediaUrl,
              'id_type': _chosenIdType,
            },
            userId: user.id!,
          );

          if (verified) {
            if (widget.skippable) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyConfirmationScreen(
                    skippable: widget.skippable,
                  ),
                ),
                (route) => false,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyConfirmationScreen(
                    skippable: widget.skippable,
                  ),
                ),
              );
            }
          }
        } catch (e) {
          // TODO: SHOW ERROR MESSAGE
        }
      }
    }
  }

  List<Widget>? _appBarActions() {
    if (widget.skippable) {
      return [
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
              (route) => false,
            );
          },
          child: Text(
            "Skip",
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
        (route) => false,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify Your Account",
                style: TextStyle(
                  fontSize: 30.0.sp,
                  color: kNavyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0.h),
              Text(
                "In order to access all of Lokal's features, we need to verify your identity",
                style: TextStyle(
                  fontSize: 16.0,
                  color: kNavyColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 75.0.h),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                child: Platform.isIOS ? iOSPicker() : androidDropDown(),
              ),
              SizedBox(height: 20.0.h),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  "UPLOAD PHOTO OF ID",
                  kTealColor,
                  false,
                  () async => this._file = await context
                      .read<MediaUtility>()
                      .showMediaDialog(context),
                ),
              ),
              SizedBox(height: 150.0.h),
              SizedBox(
                width: 120.0.w,
                child: AppButton(
                  "SUBMIT",
                  kTealColor,
                  true,
                  _file != null ? _onSubmitHandler : null,
                  textStyle: _file != null
                      ? TextStyle(
                          color: kNavyColor,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
