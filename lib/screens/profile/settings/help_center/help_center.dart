import 'package:flutter/material.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../widgets/webview_builder.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      url: kHelpCenterUrl,
      title: 'Help Center',
    );
  }
}
