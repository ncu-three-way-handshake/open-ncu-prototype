import 'package:flutter/material.dart';
import 'package:prototype/components/announcement_card.dart';
import 'package:prototype/models/scholarship_item.dart';
import 'package:prototype/services/scholarship_service.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const _tabs = ['全部', '獎學金', '工讀職缺', '校務公告', '活動'];

  late Future<List<ScholarshipItem>> _scholarshipFuture;

  @override
  void initState() {
    super.initState();
    _scholarshipFuture = ScholarshipService.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '訊息',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: FutureBuilder<List<ScholarshipItem>>(
          future: _scholarshipFuture,
          builder: (context, snapshot) {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: TabBarView(
                    children: _tabs
                        .map((tab) => _NewsTabContent(
                              category: tab,
                              items: snapshot.data ?? [],
                              isLoading: snapshot.connectionState !=
                                  ConnectionState.done,
                              error: snapshot.error,
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 1.0),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: null,
                              icon: Icon(Icons.arrow_back_ios, size: 16),
                            ),
                            Expanded(
                              child: Text(
                                '今日',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: null,
                              icon: Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NewsTabContent extends StatelessWidget {
  const _NewsTabContent({
    required this.category,
    required this.items,
    required this.isLoading,
    this.error,
  });

  final String category;
  final List<ScholarshipItem> items;
  final bool isLoading;
  final Object? error;

  List<ScholarshipItem> get _filteredItems {
    if (category == '全部') return items;
    return items.where((item) => item.tabLabel == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('載入失敗，請稍後再試'));
    }

    final displayItems = _filteredItems;
    if (displayItems.isEmpty) {
      return const Center(child: Text('目前沒有資料'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemCount: displayItems.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8.0),
      itemBuilder: (_, index) {
        final item = displayItems[index];
        return AnnouncementCard(
          label: item.tabLabel,
          title: item.title,
          date: item.endDate,
        );
      },
    );
  }
}
