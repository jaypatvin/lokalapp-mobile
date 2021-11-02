import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/custom_app_bar.dart';

class PrivacySetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Privacy Settings',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
    );
  }
}
