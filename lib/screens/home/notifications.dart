import 'package:flutter/material.dart';

import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class Notifications extends StatelessWidget {
  static const routeName = '/home/notifications';
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Notifications',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: const SizedBox(),
    );
  }
}
