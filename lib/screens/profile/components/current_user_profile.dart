import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/components/current_user_profile.vm.dart';
import '../../home/timeline.dart';
import 'my_profile_list.dart';

class CurrentUserProfile extends StatelessWidget {
  const CurrentUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _CurrentUserProfileView(),
      viewModel: CurrentUserProfileViewModel(
        context.read<PageController>(),
      ),
    );
  }
}

class _CurrentUserProfileView
    extends StatelessView<CurrentUserProfileViewModel> {
  @override
  Widget render(BuildContext context, CurrentUserProfileViewModel vm) {
    final user = context.read<Auth>().user!;
    return NestedWillPopScope(
      onWillPop: vm.onWillPop,
      child: PageView(
        controller: context.read<PageController>(),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
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
                child: Text(
                  "My Profile",
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
          ),
          GestureDetector(
            onPanUpdate: vm.onPanUpdate,
            child: Timeline(userId: user.id),
          ),
        ],
      ),
    );
  }
}
