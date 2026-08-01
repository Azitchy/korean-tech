import 'package:flutter/material.dart';

import '../data/exam_repository.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Practice Streak', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Track your daily practice and consistency from the backend.'),
          const SizedBox(height: 18),
          FutureBuilder(
            future: repo.loadStreakItems(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('No streak data has been published yet.'),
                  ),
                );
              }

              final streak = items.first;
              final days = _streakDays(streak.body, streak.metadata['days']);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(streak.title, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: days
                            .map(
                              (day) => Chip(
                                label: Text(day.$1),
                                backgroundColor: day.$2 ? Colors.green.withValues(alpha: 0.14) : null,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<(String, bool)> _streakDays(String? body, dynamic metadataDays) {
    final source = metadataDays is List && metadataDays.isNotEmpty
        ? metadataDays.map((day) => day.toString()).toList()
        : (body ?? '').split(RegExp(r'\s+')).where((day) => day.isNotEmpty).toList();

    if (source.isEmpty) {
      return const [];
    }

    return source
        .asMap()
        .entries
        .map((entry) => (entry.value, entry.key < source.length - 1))
        .toList();
  }
}
