import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = const [
      ('IELTS Foundation Course', 'Beginner', '12 lessons'),
      ('TOEFL Speaking Booster', 'Intermediate', '8 lessons'),
      ('SAT Core Math', 'Advanced', '15 lessons'),
      ('Government Jobs GK', 'Beginner', '10 lessons'),
      ('University Entrance Prep', 'Intermediate', '14 lessons'),
      ('Language Basics', 'Beginner', '9 lessons'),
      ('GRE Quant Sprint', 'Advanced', '11 lessons'),
      ('GMAT Data Insights', 'Advanced', '10 lessons'),
      ('Banking Aptitude', 'Intermediate', '13 lessons'),
      ('Daily Practice Pack', 'Mixed', '30 lessons'),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Courses', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Browse all available courses and lesson packs.'),
          const SizedBox(height: 18),
          ...courses.map(
            (course) => Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(course.$1),
                subtitle: Text('${course.$2} - ${course.$3}'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
