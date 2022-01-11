import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../../../services/api/api.dart';
import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/invite_a_friend.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/input_field.dart';
import '../../../../widgets/overlays/screen_loader.dart';

class InviteAFriend extends StatelessWidget {
  static const routeName = '/profile/inviteAFriend';
  const InviteAFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _InviteAFriendView(),
      viewModel: InviteAFriendViewModel(context.read<API>()),
    );
  }
}

class _InviteAFriendView extends HookView<InviteAFriendViewModel>
    with HookScreenLoader<InviteAFriendViewModel> {
  _InviteAFriendView({Key? key, bool reactive = true})
      : super(key: key, reactive: reactive);

  @override
  Widget screen(
    BuildContext context,
    InviteAFriendViewModel vm,
  ) {
    final _emailNode = useFocusNode();
    final _phoneNode = useFocusNode();

    final _emailController = useTextEditingController();
    final _phoneController = useTextEditingController();

    final _kbActionsRef = useRef(
      KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _emailNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: _phoneNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
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

    useEffect(
      () {
        void _emailListener() => vm.onEmailChanged(_emailController.text);

        void _phoneListener() => vm.onPhoneNumberChange(_phoneController.text);

        _emailController.addListener(_emailListener);
        _phoneController.addListener(_phoneListener);

        return () {
          _emailController.removeListener(_emailListener);
          _phoneController.removeListener(_phoneListener);
        };
      },
      [],
    );

    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        titleText: 'Invite a Friend',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(
          color: Colors.white,
        ),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Center(
          child: KeyboardActions(
            config: _kbActionsRef.value,
            tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Expand your Community!',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: kTealColor),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.0.w),
                  child: const Text(
                    "Share an invite code by entering the recipient's email "
                    'address below.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0.h),
                InputField(
                  fillColor: Colors.white,
                  controller: _emailController,
                  focusNode: _emailNode,
                  errorText: vm.emailErrorText,
                  hintText: 'Email Address',
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 20.0.h),
                //   child: Text('or'),
                // ),
                // InputField(
                //   controller: _phoneController,
                //   focusNode: _phoneNode,
                //   fillColor: Colors.white,
                //   hintText: 'Phone Number',
                //   keyboardType: TextInputType.number,
                //   enabled: false,
                // ),
                SizedBox(height: 20.0.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: AppButton(
                    'SEND INVITE CODE',
                    kTealColor,
                    true,
                    () async => performFuture<void>(vm.sendInviteCode),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
