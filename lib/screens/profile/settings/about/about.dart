import 'package:flutter/material.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../widgets/webview_builder.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      url: kAboutLokalUrl,
      title: 'About',
    );
  }
}
