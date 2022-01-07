import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '空资讯',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({Key? key}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  String userAgent = '';
  final Completer<WebViewController> _controller = Completer();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: WebView(
          initialUrl: 'https://yyue.vip',
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: userAgent,
          onWebViewCreated: (WebViewController controller) async {
            _controller.complete(controller);
            var title = await controller
                .runJavascriptReturningResult('window.navigator.userAgent');
            String encode = json.decode(title);
            setState(() {
              userAgent = encode + ' yyueEmptyApp/1.0.0';
            });
          },
          onPageStarted: (url) {},
        ),
        onWillPop: () async {
          var controller = await _controller.future;
          if (await controller.canGoBack()) {
            await controller.goBack();
            return false;
          }
          return true;
        });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.primaryColor,
      child: const SafeArea(child: WebViewWidget()),
    );
  }
}
