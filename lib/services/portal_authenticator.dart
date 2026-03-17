import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum PortalSessionStatus {
  expired,
  authenticating,
  authenticated,
  requireReauthentication,
  error,
}

class PortalAuthenticator {
  final status = ValueNotifier<PortalSessionStatus>(
    PortalSessionStatus.expired,
  );
  final portalToken = ValueNotifier<String?>(null);

  static final PortalAuthenticator _instance = PortalAuthenticator._internal();
  factory PortalAuthenticator() => _instance;
  HeadlessInAppWebView? _headless;
  PortalAuthenticator._internal();

  Future<String?> fetchPortalToken() async {
    final completer = Completer<String?>();
    _headless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri.uri(Uri.parse("https://portal.ncu.edu.tw")),
      ),
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
      onLoadStop: (controller, url) async {
        final token = await controller.evaluateJavascript(source: "token;");
        completer.complete(token);
      },
    );

    await _headless!.run();
    status.value = PortalSessionStatus.authenticating;

    final result = await completer.future;

    await _headless!.dispose();

    if (result != null) {
      status.value = PortalSessionStatus.authenticated;
    } else {
      status.value = PortalSessionStatus.expired;
    }

    return result;
  }
}
