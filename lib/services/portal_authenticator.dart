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
  Future<String?>? _fetching;
  PortalAuthenticator._internal();

  Future<String?> fetchPortalToken() async {
    if (_fetching != null) {
      return _fetching!;
    }
    _fetching = _fetchPortalTokenInternal();
    return _fetching!;
  }

  Future<String?> _fetchPortalTokenInternal() async {
    final completer = Completer<String?>();
    _headless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri.uri(Uri.parse("https://portal.ncu.edu.tw")),
      ),
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
      onLoadStop: (controller, url) async {
        final token = await controller.evaluateJavascript(source: "token;");
        if (!completer.isCompleted) {
          completer.complete(token);
        }
      },
    );

    try {
      await _headless!.run();
      status.value = PortalSessionStatus.authenticating;

      final result = await completer.future;
      final token = result?.trim();

      await _headless!.dispose();

      if (token != null && token.isNotEmpty) {
        portalToken.value = token;
        status.value = PortalSessionStatus.authenticated;
      } else {
        portalToken.value = null;
        status.value = PortalSessionStatus.expired;
      }

      return token;
    } catch (e) {
      status.value = PortalSessionStatus.error;
      debugPrint("Error occured during fetching portal token");
      debugPrintStack();
      return "";
    } finally {
      _fetching = null;
    }
  }
}
