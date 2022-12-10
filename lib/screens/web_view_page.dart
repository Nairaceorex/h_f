import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
