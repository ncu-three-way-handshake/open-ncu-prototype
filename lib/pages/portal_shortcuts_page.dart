import 'package:flutter/material.dart';
import 'package:prototype/components/shortcut.dart';
import 'package:prototype/pages/course.dart';

final List<PortalShortcutItem> defaultPortalShortcuts = [
  PortalShortcutItem(
    label: '新ee-class',
    icon: Icons.book,
    destination: PortalWebShortcutDestination(
      title: '新ee-class',
      url: Uri(scheme: 'https', host: 'ncueeclass.ncu.edu.tw'),
      authEntryUrl: Uri(scheme: 'https', host: 'portal.ncu.edu.tw'),
      sessionProbeHosts: {'eeclass.ncu.edu.tw', 'portal.ncu.edu.tw'},
    ),
  ),
  PortalShortcutItem(
    label: '選課系統',
    icon: Icons.event,
    destination: PortalInternalShortcutDestination(
      pageBuilder: (context) => const CourseSelectionPage(),
    ),
  ),
  PortalShortcutItem(
    label: '服務櫃台',
    icon: Icons.monitor,
    destination: PortalWebShortcutDestination(
      title: '服務櫃台',
      url: Uri(scheme: 'https', host: 'cis.ncu.edu.tw', path: '/iNCU/home'),
      authEntryUrl: Uri(scheme: 'https', host: 'portal.ncu.edu.tw'),
      sessionProbeHosts: {'cis.ncu.edu.tw', 'portal.ncu.edu.tw'},
    ),
  ),
  PortalShortcutItem(
    label: 'NCU Mail',
    icon: Icons.mail,
    destination: PortalWebShortcutDestination(
      title: 'NCU Mail',
      url: Uri(scheme: 'https', host: 'mail.ncu.edu.tw'),
      authEntryUrl: Uri(scheme: 'https', host: 'portal.ncu.edu.tw'),
      sessionProbeHosts: {'mail.ncu.edu.tw', 'portal.ncu.edu.tw'},
    ),
  ),
];

class PortalShortcutsPage extends StatelessWidget {
  const PortalShortcutsPage({
    super.key,
    this.title = '校務系統',
    required this.shortcuts,
    required this.onShortcutTap,
  });

  final String title;
  final List<PortalShortcutItem> shortcuts;
  final ValueChanged<PortalShortcutItem> onShortcutTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBar(hintText: '搜尋功能...', leading: Icon(Icons.search)),
            const SizedBox(height: 16.0),
            const _PortalSectionTitle(title: '常用功能'),
            const SizedBox(height: 8.0),
            _ShortcutRow(items: shortcuts, onTap: onShortcutTap),
          ],
        ),
      ),
    );
  }
}

class _PortalSectionTitle extends StatelessWidget {
  const _PortalSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.items, required this.onTap});

  final List<PortalShortcutItem> items;
  final ValueChanged<PortalShortcutItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final item in items)
            Expanded(
              child: Center(
                child: ShortcutCircular(
                  icon: item.icon,
                  label: item.label,
                  color: const Color(0xFF4A90D9),
                  onPressed: () => onTap(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PortalShortcutItem {
  const PortalShortcutItem({
    required this.label,
    required this.icon,
    required this.destination,
  });

  final String label;
  final IconData icon;
  final PortalShortcutDestination destination;
}

sealed class PortalShortcutDestination {
  const PortalShortcutDestination();
}

class PortalInternalShortcutDestination extends PortalShortcutDestination {
  const PortalInternalShortcutDestination({required this.pageBuilder});

  final WidgetBuilder pageBuilder;
}

class PortalWebShortcutDestination extends PortalShortcutDestination {
  const PortalWebShortcutDestination({
    required this.title,
    required this.url,
    this.authEntryUrl,
    this.sessionProbeHosts = const {},
  });

  final String title;
  final Uri url;
  final Uri? authEntryUrl;
  final Set<String> sessionProbeHosts;
}
