import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Courses', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Browse the backend-managed course catalog published by the admin dashboard.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          FutureBuilder<List<CourseSummaryData>>(
            future: repo.loadCourses(),
            builder: (context, snapshot) {
              final courses = snapshot.data ?? const <CourseSummaryData>[];
              if (courses.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No courses have been published yet.')),
                );
              }

              return Column(
                children: courses
                    .map(
                      (course) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _CourseTile(course: course),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SectionCard(
            title: 'Catalog Notes',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Course data comes from the Laravel `/api/v1/courses` endpoint.'),
                SizedBox(height: 8),
                Text('• Admin updates to category, subject, or course descriptions appear here automatically.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course});

  final CourseSummaryData course;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final levelLabel = course.level.isEmpty ? 'Course' : course.level;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      [course.category, course.subject].where((value) => value.isNotEmpty).join(' • '),
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(levelLabel),
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            course.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
