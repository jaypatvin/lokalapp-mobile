import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/constants/themes.dart';
import 'custom_app_bar.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String url;
  final String title;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: widget.title,
        titleStyle: TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Builder(
        builder: (context) {
          return WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            navigationDelegate: (_) => NavigationDecision.prevent,
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
            },
          );
        },
      ),
    );
  }
}

// class WebViewPage extends StatefulWidget {
//   const WebViewPage({required this.url, required this.title});

//   final String url;
//   final String title;

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State {
//     final Completer<WebViewController> _controller =
//       Completer<WebViewController>();
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

//   }

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       appBar: CustomAppBar(
//         backgroundColor: kTealColor,
//         titleText: widget.title,
//         titleStyle: TextStyle(color: Colors.white),
//         onPressedLeading: () => Navigator.pop(context),
//       ),
//       body: Builder(
//         builder: (context) {
        
//           return WebView(
//             initialUrl: 'https://www.lokalapp.ph',
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller.complete(webViewController);
//             },
//             onProgress: (int progress) {
//               print("WebView is loading (progress : $progress%)");
//             },
//             navigationDelegate: (_) => NavigationDecision.prevent,
//             onPageStarted: (String url) {
//               print('Page started loading: $url');
//             },
//             onPageFinished: (String url) {
//               print('Page finished loading: $url');
//             },
//           );
//         },
//       ),
//     );
//   }
// }
