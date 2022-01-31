import 'package:flutter/material.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../widgets/webview_builder.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      url: kTermsOfServiceUrl,
      title: 'Terms of Service',
    );
  }
}
