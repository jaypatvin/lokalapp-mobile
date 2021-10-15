import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import '../../widgets/screen_loader.dart';

import '../../providers/invite.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../providers/user.dart';
import '../../utils/constants.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import 'community.dart';
import 'profile_registration.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> with ScreenLoader {
  final FocusNode _inviteTextNode = FocusNode();
  final TextEditingController _codeController = TextEditingController();
  bool _displayError = false;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey.shade200,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _inviteTextNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  Future<void> _validateInviteCode(BuildContext context, String code) async {
    final invite = context.read<Invite>();
    final user = context.read<CurrentUser>();

    String communityId = await invite.check(code, user.idToken) ?? "";
    if (communityId.isNotEmpty) {
      final fireUser = FirebaseAuth.instance.currentUser;
      context.read<AuthBody>().update(communityId: communityId);
      if (_displayError) {
        setState(() {
          _displayError = false;
        });
      }
      if (fireUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileRegistration(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Community()),
        );
      }
    } else {
      setState(() {
        _displayError = true;
      });
    }
  }

  Future<void> _showInviteCodeDescription() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0.r),
          ),
          insetPadding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(25.0.w),
            height: 230.0.h,
            //width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "What is an Invite Code?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0.sp,
                  ),
                ),
                Text(
                  kInviteCodeDescription,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 14.0.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 120.w,
                  child: AppButton(
                    "Okay",
                    kTealColor,
                    false,
                    () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 38.0.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter invite code",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 10.0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0.w),
              child: Text(
                "An invite code is required to create an account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(height: 45.0.h),
            KeyboardActions(
              disableScroll: true,
              config: _buildConfig(context),
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              child: TextField(
                focusNode: _inviteTextNode,
                controller: _codeController,
                style: TextStyle(fontWeight: FontWeight.w500),
                decoration: kInputDecoration.copyWith(
                  hintText: "Invite Code",
                  errorText: _displayError ? kInviteCodeError : null,
                  errorMaxLines: 2,
                ),
              ),
            ),
            SizedBox(height: 24.0.h),
            SizedBox(
              width: 100.0.w,
              child: AppButton(
                "JOIN",
                kTealColor,
                true,
                () async => await performFuture<void>(() async =>
                    await _validateInviteCode(context, _codeController.text)),
                textStyle: TextStyle(color: kNavyColor),
              ),
            ),
            SizedBox(height: 18.0.h),
            InkWell(
              child: Text(
                "WHAT'S AN INVITE CODE?",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              onTap: _showInviteCodeDescription,
            ),
          ],
        ),
      ),
    );
  }
}
