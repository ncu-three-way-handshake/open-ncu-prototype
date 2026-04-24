import 'package:flutter/material.dart';
import 'package:prototype/components/portal/shortcut.dart';
import 'package:prototype/services/portal_authenticator.dart';

const _portalHost = 'portal.ncu.edu.tw';

List<PortalShortcutSection> get defaultPortalShortcutSections => [
  PortalShortcutSection(
    title: '常用服務',
    items: [
      _portalSystemShortcut('新ee-class', Icons.book, '/system/ncueeclass'),
      _portalSystemShortcut('選課系統', Icons.event, '/system/cs'),
      _portalSystemShortcut('服務櫃台', Icons.support_agent, '/system/incu'),
      _portalSystemShortcut('NCU Mail', Icons.mail, '/system/129'),
      _portalSystemShortcut('成績查詢', Icons.grading, '/system/incu-studentscore'),
      _portalSystemShortcut('人事系統', Icons.badge, '/system/humanoauth'),
      _blankWebShortcut('（未定）', Icons.help_outline),
      _portalSystemShortcut('宿舍網路系統', Icons.wifi, '/system/dormnet'),
    ],
  ),
  PortalShortcutSection(
    title: '課務相關',
    items: [
      _portalSystemShortcut('新ee-class', Icons.book, '/system/ncueeclass'),
      _portalSystemShortcut('選課系統', Icons.event, '/system/cs'),
      _portalSystemShortcut('成績查詢', Icons.grading, '/system/incu-studentscore'),
      _portalSystemShortcut(
        '期中預警查詢',
        Icons.warning_amber_rounded,
        '/system/incu-ewarningstudent',
      ),
    ],
  ),
  PortalShortcutSection(
    title: '學務相關',
    items: [
      _portalSystemShortcut('學生證掛失', Icons.credit_card_off, '/system/32'),
      _portalSystemShortcut(
        '學籍系統',
        Icons.account_balance,
        '/system/incu-registrationflow',
      ),
      _portalSystemShortcut('畢業資格審查', Icons.school, '/system/incu-graduate-2'),
      _portalSystemShortcut('學費繳費證明', Icons.receipt_long, '/system/tuition'),
    ],
  ),
  PortalShortcutSection(
    title: '可利用資源',
    items: [
      _portalSystemShortcut(
        '個別諮商',
        Icons.volunteer_activism,
        '/system/consult',
      ),
      _portalSystemShortcut(
        '圖書館服務平台',
        Icons.local_library,
        '/system/library-cloud-services',
      ),
    ],
  ),
  PortalShortcutSection(
    title: '電算中心',
    items: [
      _portalSystemShortcut('宿舍網路', Icons.router, '/system/dormnet'),
      _portalSystemShortcut('客服中心', Icons.headset_mic, '/system/sdsystem'),
      _portalSystemShortcut(
        'Office365',
        Icons.workspaces_outline,
        '/system/office365',
      ),
      _portalSystemShortcut('G Suite', Icons.apps, '/system/gsuite'),
    ],
  ),
  PortalShortcutSection(
    title: '財務相關',
    items: [
      _portalSystemShortcut('學費繳費單', Icons.request_quote, '/system/82'),
      _portalSystemShortcut('學費繳費證明', Icons.receipt_long, '/system/tuition'),
      _portalSystemShortcut('人事系統', Icons.badge, '/system/humanoauth'),
      _portalSystemShortcut(
        '獎助學金暨工讀管理系統',
        Icons.workspace_premium,
        '/system/134',
      ),
      _portalSystemShortcut('就學補助系統', Icons.savings, '/system/42'),
      _portalSystemShortcut('撥帳系統', Icons.account_balance_wallet, '/system/46'),
    ],
  ),
];

PortalShortcutItem _portalSystemShortcut(
  String label,
  IconData icon,
  String path,
) {
  final token = PortalAuthenticator().portalToken.value?.trim();
  final queryParameters = <String, String>{};
  if (token != null && token.isNotEmpty) {
    queryParameters['token'] = token;
  }

  return PortalShortcutItem(
    label: label,
    icon: icon,
    destination: PortalWebShortcutDestination(
      title: label,
      targetUrl: Uri(
        scheme: 'https',
        host: _portalHost,
        path: path.startsWith('/') ? path.substring(1) : path,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      ),
      authEntryUrl: Uri(scheme: 'https', host: _portalHost),
      sessionProbeHosts: const {_portalHost},
    ),
  );
}

PortalShortcutItem _blankWebShortcut(String label, IconData icon) {
  return PortalShortcutItem(
    label: label,
    icon: icon,
    destination: PortalWebShortcutDestination(
      title: label,
      targetUrl: null,
      authEntryUrl: Uri(scheme: 'https', host: _portalHost),
      sessionProbeHosts: const {_portalHost},
    ),
  );
}

class PortalShortcutsPage extends StatefulWidget {
  const PortalShortcutsPage({
    super.key,
    this.title = '校務系統',
    required this.sections,
    required this.onShortcutTap,
    this.appBarActions,
  });

  final String title;
  final List<PortalShortcutSection> sections;
  final ValueChanged<PortalShortcutItem> onShortcutTap;
  final List<Widget>? appBarActions;

  @override
  State<PortalShortcutsPage> createState() => _PortalShortcutsPageState();
}

class _PortalShortcutsPageState extends State<PortalShortcutsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSections = widget.sections
        .map((section) {
          final filteredItems = section.items
              .where(
                (item) => item.label.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
          if (filteredItems.isEmpty) return null;
          return PortalShortcutSection(
            title: section.title,
            items: filteredItems,
          );
        })
        .whereType<PortalShortcutSection>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: widget.appBarActions,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          SearchBar(
            hintText: '搜尋功能...',
            leading: const Icon(Icons.search),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          if (filteredSections.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Center(child: Text('找不到相關功能')),
            )
          else
            for (final section in filteredSections) ...[
              _PortalSectionTitle(title: section.title),
              const SizedBox(height: 8.0),
              _ShortcutGrid(items: section.items, onTap: widget.onShortcutTap),
              const SizedBox(height: 20.0),
            ],
        ],
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
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }
}

class _ShortcutGrid extends StatelessWidget {
  const _ShortcutGrid({required this.items, required this.onTap});

  final List<PortalShortcutItem> items;
  final ValueChanged<PortalShortcutItem> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        const columns = 4;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 12.0,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
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
        );
      },
    );
  }
}

class PortalShortcutSection {
  const PortalShortcutSection({required this.title, required this.items});

  final String title;
  final List<PortalShortcutItem> items;
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
    required this.targetUrl,
    this.authEntryUrl,
    this.sessionProbeHosts = const {},
  });

  final String title;
  final Uri? targetUrl;
  final Uri? authEntryUrl;
  final Set<String> sessionProbeHosts;
}
