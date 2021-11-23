import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/lokal_invite.dart';
import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/stateless.view.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/invite_sent.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';

class InviteSent extends StatelessWidget {
  const InviteSent(this.invite);

  final LokalInvite invite;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _InviteSentView(),
      viewModel: InviteSentViewModel(this.invite),
    );
  }
}

class _InviteSentView extends StatelessView<InviteSentViewModel> {
  @override
  Widget render(BuildContext context, InviteSentViewModel vm) {
    return Scaffold(
      backgroundColor: Color(0XFFF1FAFF),
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
                      .headline6!
                      .copyWith(color: kTealColor),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.0.w),
        child: Column(
          children: [
            Lottie.asset(kAnimationOk, fit: BoxFit.cover),
            SizedBox(height: 15.h),
            Container(
              child: Text(
                'Invite Sent!',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: kTealColor),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'Your friend should receive this invite code within a '
              'few minutes.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            Text('The invite code is:'),
            Text(
              vm.inviteCode,
              style: Theme.of(context).textTheme.headline3,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0.w),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  'COPY INVITE CODE',
                  kTealColor,
                  true,
                  vm.copyToClipboard,
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
          ],
        ),
      ),
    );
  }
}
