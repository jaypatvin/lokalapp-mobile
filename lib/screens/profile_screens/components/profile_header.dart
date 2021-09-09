import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/user.dart';
import '../../chat/components/chat_avatar.dart';
import '../edit_profile.dart';
import '../settings/settings.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    return Container(
      height: 150.0.h,
      padding: EdgeInsets.only(top: 10.0.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffFFC700), Colors.black45],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.settings,
              size: 30.0.r,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0.h),
            child: Column(
              children: [
                ChatAvatar(
                  displayName: user.displayName,
                  displayPhoto: user.profilePhoto,
                  radius: 40.0.r,
                ),
                Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.more_horiz,
              size: 30.0.r,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
