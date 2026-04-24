import 'package:flutter/material.dart';

class TimetableCourseCard extends StatelessWidget {
  const TimetableCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Timetable Course Card'),
      ),
    );
  }
}
