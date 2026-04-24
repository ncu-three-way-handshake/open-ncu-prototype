import 'package:flutter/material.dart';

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    super.key,
    required this.courseName,
    required this.length,
  });

  final String courseName;
  final int length;

  static const double _width = 50.0;
  static const double _unitHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.withValues(alpha: 0.2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: _width,
          height: _unitHeight * length,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            courseName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
