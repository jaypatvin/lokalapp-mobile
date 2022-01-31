import 'package:flutter/material.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../widgets/webview_builder.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      url: kAboutLokalUrl,
      title: 'About',
    );
  }
}
