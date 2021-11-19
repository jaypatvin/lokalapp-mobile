import 'package:flutter/material.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../widgets/webview_builder.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      url: kPrivacyPolicyUrl,
      title: 'Privacy Policy',
    );
  }
}
