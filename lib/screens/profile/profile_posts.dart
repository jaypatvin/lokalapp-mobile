import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import 'components/timeline.dart';

class ProfilePosts extends StatelessWidget {
  const ProfilePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: const CustomAppBar(
        titleText: 'My Posts',
        titleStyle: TextStyle(color: kYellowColor),
        backgroundColor: kTealColor,
      ),
      body: Timeline(
        userId: context.read<Auth>().user?.id,
      ),
    );
  }
}
