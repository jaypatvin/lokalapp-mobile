import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/descriptions.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/invite_screen.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/constrained_scrollview.dart';
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
    final inviteFocusNode = useFocusNode();
    final keyboardConfig = useMemoized<KeyboardActionsConfig>(
      () => KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: inviteFocusNode,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        leadingColor: kTealColor,
        onPressedLeading: () => Navigator.maybePop(context),
      ),
      body: ConstrainedScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter invite code',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 12),
              Text(
                'An invite code is required to create an account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 28),
              KeyboardActions(
                disableScroll: true,
                config: keyboardConfig,
                child: TextField(
                  focusNode: inviteFocusNode,
                  onChanged: vm.onInviteCodeChanged,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Invite Code',
                    errorText: vm.displayError ? kErrorInviteCode : null,
                    errorMaxLines: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton.filled(
                text: 'JOIN',
                onPressed: () async => performFuture<void>(
                  () async {
                    inviteFocusNode.unfocus();
                    await vm.validateInviteCode();
                  },
                ),
                textStyle: const TextStyle(color: kNavyColor),
              ),
              const SizedBox(height: 51),
              InkWell(
                child: Text(
                  "WHAT'S AN INVITE CODE?",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: kTealColor),
                ),
                onTap: () => vm.showInviteCodeDescription(
                  const _InviteCodeDescription(),
                ),
              ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(25.0),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(25.0),
        height: 235,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What is an Invite Code?',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black),
            ),
            Text(
              kDescriptionInviteCode,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            AppButton.transparent(
              text: 'Okay',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
