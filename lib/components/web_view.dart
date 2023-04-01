import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:coverlo/screens/payment_screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class MyWebView extends StatefulWidget {
  final String paymentData;
  final String webUrl;
  final String webViewName;
  const MyWebView(
      {super.key,
      required this.paymentData,
      required this.webUrl,
      required this.webViewName});

  @override
  WebView createState() => WebView();
}

class WebView extends State<MyWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  Uri url = Uri.parse("about:blank");
  double progress = 0;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return Future.value(false);
    } else {
      if (context.mounted) {
        Navigator.popAndPushNamed(context, PaymentScreen.routeName);
      }
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _goBack(context),
        child: Scaffold(
            appBar: AppBar(title: Text(widget.webViewName)),
            body: SafeArea(
                child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(widget.webUrl),
                          body: Uint8List.fromList(
                              utf8.encode(widget.paymentData)),
                          method: "POST",
                          headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                          }),
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        // print(widget.webUrl);
                        setState(() {
                          this.url = Uri.parse(url.toString());
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunchUrl(url)) {
                            // Launch the App
                            await launchUrl(
                              url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = Uri.parse(url.toString());
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          this.url = Uri.parse(url.toString());
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        // ignore: avoid_print
                        print("CONSOLE MESSAGE: $consoleMessage");
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Icon(Icons.arrow_back),
                    onPressed: () {
                      webViewController?.goBack();
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      webViewController?.goForward();
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () {
                      webViewController?.reload();
                    },
                  ),
                ],
              ),
            ]))));
  }
}
