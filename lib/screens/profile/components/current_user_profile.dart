import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/components/current_user_profile.vm.dart';
import 'my_profile_list.dart';

class CurrentUserProfile extends StatelessWidget {
  const CurrentUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _CurrentUserProfileView(),
      viewModel: CurrentUserProfileViewModel(),
    );
  }
}

class _CurrentUserProfileView
    extends StatelessView<CurrentUserProfileViewModel> {
  @override
  Widget render(BuildContext context, CurrentUserProfileViewModel vm) {
    return Column(
      children: [
        Container(
          color: kInviteScreenColor,
          padding: EdgeInsets.fromLTRB(
            10.0.w,
            20.0.w,
            10.0.w,
            10.0.w,
          ),
          width: double.infinity,
          child: const Text(
            'My Profile',
            style: TextStyle(
              color: kTealColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: MyProfileList(
            onMyPostsTap: vm.onMyPostsTap,
            onInviteFriend: vm.onInviteFriend,
            onWishlistTap: vm.onWishlistTap,
          ),
        ),
      ],
    );
  }
}
