import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
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

  int _loadingPercentage = 0;
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
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  debugPrint('WebView is loading (progress : $progress%)');
                  setState(() {
                    _loadingPercentage = progress;
                  });
                },
                navigationDelegate: (_) => NavigationDecision.prevent,
                onPageStarted: (String url) {
                  debugPrint('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  debugPrint('Page finished loading: $url');
                  setState(() {
                    _loadingPercentage = 100;
                  });
                },
                onWebResourceError: (error) {
                  showToast(error.description);
                  FirebaseCrashlytics.instance.recordError(
                    error,
                    StackTrace.current,
                  );
                },
              ),
              if (_loadingPercentage < 100)
                Center(
                  child: CircularProgressIndicator(
                    value: _loadingPercentage / 100,
                    valueColor: const AlwaysStoppedAnimation<Color>(kTealColor),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
