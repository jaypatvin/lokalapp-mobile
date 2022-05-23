import 'package:flutter/material.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 14,
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
