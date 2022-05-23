import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/lokal_invite.dart';
import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/stateless.view.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/invite_sent.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/constrained_scrollview.dart';

class InviteSent extends StatelessWidget {
  const InviteSent(this.invite);

  final LokalInvite invite;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _InviteSentView(),
      viewModel: InviteSentViewModel(invite),
    );
  }
}

class _InviteSentView extends StatelessView<InviteSentViewModel> {
  @override
  Widget render(BuildContext context, InviteSentViewModel vm) {
    return Scaffold(
      backgroundColor: const Color(0XFFF1FAFF),
      appBar: CustomAppBar(
        buildLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Done',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: kTealColor),
                ),
              ),
            ),
          )
        ],
      ),
      body: ConstrainedScrollView(
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset(
                kAnimationOk,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Invite Sent!',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: kTealColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 61),
              child: Text(
                'Your friend should receive this invite code within a '
                'few minutes.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 52),
            Text(
              'The invite code is:',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            ),
            Text(
              vm.inviteCode,
              style:
                  Theme.of(context).textTheme.headline6?.copyWith(fontSize: 54),
            ),
            const SizedBox(height: 16),
            AppButton.filled(
              text: 'COPY INVITE CODE',
              onPressed: vm.copyToClipboard,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
