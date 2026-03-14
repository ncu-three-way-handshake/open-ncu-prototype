import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prototype/pages/portal_shortcuts_page.dart';
import 'package:prototype/pages/portal_web_view.dart';
import 'package:prototype/services/portal_session_manager.dart';
import 'package:prototype/widgets/portal_session_indicator.dart';

class PortalPage extends StatefulWidget {
  const PortalPage({super.key});

  @override
  State<PortalPage> createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  static const _portalAuthHost = 'portal.ncu.edu.tw';

  final PortalSessionManager _sessionManager = PortalSessionManager(
    authHosts: {_portalAuthHost},
  );

  @override
  void initState() {
    super.initState();
    unawaited(_sessionManager.refreshSessionStatus());
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PortalShortcutsPage(
      sections: defaultPortalShortcutSections,
      appBarActions: [
        PortalSessionIndicator(
          sessionManager: _sessionManager,
          onRefresh: () => unawaited(_sessionManager.refreshSessionStatus()),
          onOpenLogin: () => unawaited(_openPortalLogin(context)),
        ),
      ],
      onShortcutTap: (item) => unawaited(_openShortcut(context, item)),
    );
  }

  Future<void> _openPortalLogin(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PortalWebViewPage(
          title: 'Portal 登入',
          targetUrl: Uri(scheme: 'https', host: _portalAuthHost),
          authEntryUrl: Uri(scheme: 'https', host: _portalAuthHost),
          sessionProbeHosts: const {_portalAuthHost},
          onSessionProbe: (_, currentUrl) {
            return _sessionManager.refreshSessionStatus(
              probeHosts: {currentUrl.host, _portalAuthHost},
            );
          },
        ),
      ),
    );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('此功能尚未設定連結')),
          );
          return Future.value();
        }
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PortalWebViewPage(
              title: title,
              targetUrl: targetUrl,
              authEntryUrl: authEntryUrl,
              sessionProbeHosts: sessionProbeHosts,
              onSessionProbe: (_, currentUrl) {
                return _sessionManager.refreshSessionStatus(
                  probeHosts: {
                    ...sessionProbeHosts,
                    currentUrl.host,
                    _portalAuthHost,
                  },
                );
              },
            ),
          ),
        );
    }
  }
}
