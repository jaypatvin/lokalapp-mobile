import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/descriptions.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/invite_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/overlays/screen_loader.dart';

class InvitePage extends StatelessWidget {
  static const routeName = '/invite';
  const InvitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _InvitePageView(),
      viewModel: InviteScreenViewModel(),
    );
  }
}

class _InvitePageView extends HookView<InviteScreenViewModel>
    with HookScreenLoader<InviteScreenViewModel> {
  @override
  Widget screen(
    BuildContext context,
    InviteScreenViewModel vm,
  ) {
    final _inviteFocusNode = useFocusNode();
    final _keyboardConfig = useMemoized<KeyboardActionsConfig>(
      () => KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: _inviteFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    "Done",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        leadingColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
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
              config: _keyboardConfig,
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              child: TextField(
                focusNode: _inviteFocusNode,
                onChanged: vm.onInviteCodeChanged,
                style: TextStyle(fontWeight: FontWeight.w500),
                decoration: kInputDecoration.copyWith(
                  hintText: "Invite Code",
                  errorText: vm.displayError ? kErrorInviteCode : null,
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
                () async => await performFuture<void>(
                  () async => await vm.validateInviteCode(),
                ),
                textStyle: TextStyle(color: kNavyColor),
              ),
            ),
            SizedBox(height: 18.0.h),
            InkWell(
              child: Text(
                "WHAT'S AN INVITE CODE?",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              onTap: () => vm.showInviteCodeDescription(
                _InviteCodeDescription(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteCodeDescription extends StatelessWidget {
  const _InviteCodeDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0.r),
      ),
      insetPadding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(25.0.w),
        height: 230.0.h,
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
              kDescriptionInviteCode,
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
  }
}
