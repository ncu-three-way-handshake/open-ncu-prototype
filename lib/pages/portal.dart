import 'package:flutter/material.dart';
import 'package:prototype/pages/portal_shortcuts_page.dart';
import 'package:prototype/pages/portal_web_view.dart';

class PortalPage extends StatelessWidget {
  const PortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortalShortcutsPage(
      shortcuts: defaultPortalShortcuts,
      onShortcutTap: (item) => _openShortcut(context, item),
    );
  }

  void _openShortcut(BuildContext context, PortalShortcutItem item) {
    final destination = item.destination;

    switch (destination) {
      case PortalInternalShortcutDestination(:final pageBuilder):
        Navigator.of(context).push(MaterialPageRoute(builder: pageBuilder));
      case PortalWebShortcutDestination(
        :final title,
        :final url,
        :final authEntryUrl,
        :final sessionProbeHosts,
      ):
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PortalWebViewPage(
              title: title,
              targetUrl: url,
              authEntryUrl: authEntryUrl,
              sessionProbeHosts: sessionProbeHosts,
            ),
          ),
        );
    }
  }
}
