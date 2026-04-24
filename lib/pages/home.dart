import 'package:flutter/material.dart';

import 'package:prototype/components/home/section_header.dart';
import 'package:prototype/components/home/course_card.dart';
import 'package:prototype/components/home/quick_button.dart';
import 'package:prototype/components/portal/shortcut.dart';
import 'package:prototype/pages/course.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _horizontalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '神奇松果',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildCourseSection(context),
          _buildShortcutSection(context),
          _buildQuickActionSection(context),
        ],
      ),
    );
  }

  Widget _buildCourseSection(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SectionHeader(
          title: '接下來的課程',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CourseSelectionPage(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
                vertical: 4.0,
              ),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) => const CourseCard(
                courseName: '計算機概論 I',
                courseTime: '週四 13:00-16:00',
                courseLocation: '工程五館 A207',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutSection(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SectionHeader(
          title: '捷徑',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CourseSelectionPage(),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: 8.0,
          ),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,        
              mainAxisSpacing: 12.0,     
              crossAxisSpacing: 12.0,    
              childAspectRatio: 0.85,    
            ),
            delegate: SliverChildListDelegate([
              const ShortcutCircular(
                icon: Icons.school,
                label: '校務系統',
                color: Color(0xFF4A90D9),
              ),
              const ShortcutCircular(
                icon: Icons.calendar_today,
                label: '行事曆',
                color: Color(0xFFE57373),
              ),
              const ShortcutCircular(
                icon: Icons.mail_outline,
                label: '信箱',
                color: Color(0xFF66BB6A),
              ),
              const ShortcutCircular(
                icon: Icons.library_books,
                label: '圖書館',
                color: Color(0xFFFF9800),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickButtonRow(List<({IconData icon, String label})> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: items
            .expand(
              (item) => [
                if (items.indexOf(item) > 0) const SizedBox(width: 10.0),
                QuickButton(
                  icon: item.icon,
                  label: item.label,
                  onPressed: () => print(item.label),
                ),
              ],
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuickActionSection(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        const SectionHeader(title: '快速功能表'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: 4.0,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildQuickButtonRow([
                (icon: Icons.book, label: '成績查詢'),
                (icon: Icons.explore, label: '選課系統'),
              ]),
              _buildQuickButtonRow([
                (icon: Icons.book, label: '成績查詢'),
                (icon: Icons.explore, label: '選課系統'),
              ]),
              _buildQuickButtonRow([
                (icon: Icons.book, label: '成績查詢'),
                (icon: Icons.explore, label: '選課系統'),
              ]),
            ]),
          ),
        ),
      ],
    );
  }
}

