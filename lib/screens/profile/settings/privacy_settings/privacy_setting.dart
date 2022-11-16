import 'package:flutter/material.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/custom_app_bar.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Privacy Settings',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
    );
  }
}
