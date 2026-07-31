import 'package:flutter/material.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final days = const [
      ('Mon', true),
      ('Tue', true),
      ('Wed', true),
      ('Thu', true),
      ('Fri', true),
      ('Sat', true),
      ('Sun', true),
      ('Mon', true),
      ('Tue', true),
      ('Wed', false),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Practice Streak', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Track your daily practice and consistency.'),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text('14 day streak', style: Theme.of(context).textTheme.headlineMedium),
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
          ),
        ],
      ),
    );
  }
}
