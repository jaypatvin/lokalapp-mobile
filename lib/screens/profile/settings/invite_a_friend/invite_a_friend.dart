import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  const InviteAFriend({super.key});

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
  // ignore: unused_element
  _InviteAFriendView({super.key, super.reactive});

  @override
  Widget screen(
    BuildContext context,
    InviteAFriendViewModel vm,
  ) {
    final emailNode = useFocusNode();
    final phoneNode = useFocusNode();

    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();

    final kbActionsRef = useRef(
      KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: emailNode,
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
            focusNode: phoneNode,
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
        void emailListener() => vm.onEmailChanged(emailController.text);

        void phoneListener() => vm.onPhoneNumberChange(phoneController.text);

        emailController.addListener(emailListener);
        phoneController.addListener(phoneListener);

        return () {
          emailController.removeListener(emailListener);
          phoneController.removeListener(phoneListener);
        };
      },
      [],
    );

    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        titleText: 'Invite a Friend',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: KeyboardActions(
        config: kbActionsRef.value,
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
                      .headline5
                      ?.copyWith(color: kTealColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 51),
              child: Text(
                "Share an invite code by entering the recipient's email "
                'address below.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: InputField(
                fillColor: Colors.white,
                controller: emailController,
                focusNode: emailNode,
                errorText: vm.emailErrorText,
                hintText: 'Email Address',
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 8),
            //   child: Text('or'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 45),
            //   child: InputField(
            //     controller: _phoneController,
            //     focusNode: _phoneNode,
            //     fillColor: Colors.white,
            //     hintText: 'Phone Number',
            //     keyboardType: TextInputType.number,
            //     enabled: false,
            //   ),
            // ),
            const SizedBox(height: 27),
            AppButton.filled(
              text: 'SEND INVITE CODE',
              onPressed: () async => performFuture<void>(vm.sendInviteCode),
            ),
          ],
        ),
      ),
    );
  }
}
