import 'package:flutter/material.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../widgets/webview_builder.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});
  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      url: kHelpCenterUrl,
      title: 'Help Center',
    );
  }
}
