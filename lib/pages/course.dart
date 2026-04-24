// lib/pages/course_selection.dart
import 'package:flutter/material.dart';

class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  bool _showWeekends = false;

  static const List<String> _periods = [
    '1',
    '2',
    '3',
    '4',
    'Z',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
  ];
  static const List<String> _weekDays = ['一', '二', '三', '四', '五', '六', '日'];
  static const double _rowHeight = 50.0;
  static const int _periodColumnFlex = 1;
  static const int _dayCellFlex = 2;

  List<String> get _visibleDays =>
      _showWeekends ? _weekDays : _weekDays.sublist(0, 5);

  @override
  Widget build(BuildContext context) {
    final days = _visibleDays;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildHeader(days),
          const Divider(height: 1),
          Expanded(child: _buildTimetable(context, days)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: const Text('課表', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '週末',
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
            Switch(
              value: _showWeekends,
              onChanged: (v) => setState(() => _showWeekends = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(List<String> days) {
    return Row(
      children: [
        const Spacer(flex: _periodColumnFlex),
        ...days.map(
          (day) => Expanded(
            flex: _dayCellFlex,
            child: SizedBox(
              height: 36,
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimetable(BuildContext context, List<String> days) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          _periods.length,
          (index) => _buildPeriodRow(context, index, days),
        ),
      ),
    );
  }

  Widget _buildPeriodRow(BuildContext context, int index, List<String> days) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEven = index.isEven;

    return Container(
      color: isEven ? colorScheme.surface : colorScheme.surfaceContainerHighest,
      height: _rowHeight,
      child: Row(
        children: [
          Expanded(
            flex: _periodColumnFlex,
            child: Center(
              child: Text(
                _periods[index],
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          ...List.generate(
            days.length,
            (col) => _buildDayCell(context, col, index),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int col, int periodIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: _dayCellFlex,
      child: GestureDetector(
        onTap: () =>
            _showSearchModal(context, day: col, periodIndex: periodIndex),
        child: Container(
          height: _rowHeight,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchModal(
    BuildContext context, {
    required int day,
    required int periodIndex,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final period = _periods[periodIndex];
    final days = _visibleDays;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '新增課程 (週${days[day]} 第$period 節)',
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: '輸入課程名稱或代碼搜尋...',
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const Expanded(child: Center(child: Text('請輸入關鍵字搜尋 NCU 課程資料'))),
          ],
        ),
      ),
    );
  }
}
