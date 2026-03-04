import 'package:flutter/material.dart';
import 'package:prototype/components/announcement_card.dart';
import 'package:prototype/components/shortcut.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  static const _horizontalPadding = 16.0;

  static const _tabs = ['獎學金', '工讀職缺', '校務公告', '活動'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('訊息'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: Column(
          children: [
            _buildShortcutBar(),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: _tabs
                    .map((tab) => _NewsTabContent(category: tab))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 12.0,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: ShortcutCircular(
                icon: Icons.star_outline,
                label: '收藏',
                color: Color(0xFFFFB300),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ShortcutCircular(
                icon: Icons.history,
                label: '已讀',
                color: Color(0xFF4A90D9),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ShortcutCircular(
                icon: Icons.notifications_none,
                label: '訂閱',
                color: Color(0xFFE57373),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ShortcutCircular(
                icon: Icons.search,
                label: '搜尋',
                color: Color(0xFF66BB6A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsTabContent extends StatelessWidget {
  const _NewsTabContent({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: 8.0),
      itemBuilder: (_, index) {
        return AnnouncementCard(
          label: category,
          title: '$category消息 #${index + 1}',
        );
      },
    );
  }
}
