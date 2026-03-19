import 'dart:async';

import 'package:flutter/foundation.dart';
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

  // Fetches the portal token, ensuring only one fetch operation is active at a time
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
        // Assuming the portal sets a global JS variable `window.token` upon successful login
        final token = await controller.evaluateJavascript(source: "window.token;");
        if (!completer.isCompleted) {
          completer.complete(token);
        }
      },
    );

    try {
      status.value = PortalSessionStatus.authenticating;
      await _headless!.run();

      // 30s timeout to prevent hanging indefinitely
      final result = await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint("Portal auth timed out");
          return null;
        },
      );

      final token = result?.trim();

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
      debugPrint("Error occurred during fetching portal token: $e");
      return null;
    } finally {
      await _headless?.dispose();
      _headless = null;
      _fetching = null;
    }
  }
}