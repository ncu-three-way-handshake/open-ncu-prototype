import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:prototype/pages/portal_shortcuts_page.dart';
import 'package:prototype/pages/portal_web_view.dart';
import 'package:prototype/services/portal_authenticator.dart';
import 'package:prototype/widgets/portal_session_indicator.dart';

class PortalPage extends StatefulWidget {
  const PortalPage({super.key});

  @override
  State<PortalPage> createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  static const _portalAuthHost = 'portal.ncu.edu.tw';

  final PortalAuthenticator _authenticator = PortalAuthenticator();

  @override
  void initState() {
    super.initState();
    unawaited(_refreshPortalAuth());
  }

  @override
  Widget build(BuildContext context) {
    return PortalShortcutsPage(
      sections: defaultPortalShortcutSections,
      appBarActions: [
        PortalSessionIndicator(
          authenticator: _authenticator,
          onRefresh: () => unawaited(_refreshPortalAuth()),
          onOpenLogin: () => unawaited(_openPortalLogin(context)),
        ),
      ],
      onShortcutTap: (item) => unawaited(_openShortcut(context, item)),
    );
  }

  Future<void> _refreshPortalAuth() async {
    try {
      await _authenticator.fetchPortalToken();
    } catch (_) {
      // Status is updated inside PortalAuthenticator.
    }
  }

  Future<void> _openPortalLogin(BuildContext context) {
    return Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PortalWebViewPage(
              title: 'Portal 登入',
              targetUrl: Uri(scheme: 'https', host: _portalAuthHost),
              authEntryUrl: Uri(scheme: 'https', host: _portalAuthHost),
              sessionProbeHosts: const {_portalAuthHost},
              onSessionProbe: _probeAuthStateFromWebView,
            ),
          ),
        )
        .then((_) => _refreshPortalAuth());
  }

  Future<void> _openShortcut(BuildContext context, PortalShortcutItem item) {
    final destination = item.destination;

    switch (destination) {
      case PortalInternalShortcutDestination(:final pageBuilder):
        return Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: pageBuilder));
      case PortalWebShortcutDestination(
        :final title,
        :final targetUrl,
        :final authEntryUrl,
        :final sessionProbeHosts,
      ):
        if (targetUrl == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('此功能尚未設定連結')));
          return Future.value();
        }
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PortalWebViewPage(
              title: title,
              targetUrl: targetUrl,
              authEntryUrl: authEntryUrl,
              sessionProbeHosts: sessionProbeHosts,
              onSessionProbe: _probeAuthStateFromWebView,
            ),
          ),
        );
    }
  }

  Future<void> _probeAuthStateFromWebView(
    InAppWebViewController controller,
    Uri currentUrl,
  ) async {
    if (currentUrl.host != _portalAuthHost) return;
    await _authenticator.fetchPortalToken();
  }
}
