import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Results & Performance', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Track score history, accuracy, and weekly progress.'),
          const SizedBox(height: 18),
          FutureBuilder<List<ResultSnapshot>>(
            future: repo.loadResults(),
            builder: (context, snapshot) {
              final results = snapshot.data ?? const [];
              return Column(
                children: results
                    .map((result) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ResultCard(result: result),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 4),
          SectionCard(
            title: 'Weekly Progress',
            child: FutureBuilder<List<PerformancePoint>>(
              future: repo.loadWeeklyProgress(),
              builder: (context, snapshot) {
                final points = snapshot.data ?? const [];
                return Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: points
                      .map(
                        (point) => _ProgressBar(point: point),
                      )
                      .toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'Leaderboard Snapshot',
            child: Column(
              children: [
                _LeaderboardRow(rank: 1, name: 'Aarav Shrestha', score: '98', subtitle: 'Fastest completion: 14:22'),
                SizedBox(height: 10),
                _LeaderboardRow(rank: 2, name: 'Sita Karki', score: '95', subtitle: 'Fastest completion: 15:08'),
                SizedBox(height: 10),
                _LeaderboardRow(rank: 3, name: 'Nabin Rai', score: '94', subtitle: 'Fastest completion: 15:41'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final ResultSnapshot result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(result.title, style: Theme.of(context).textTheme.titleLarge),
                ),
                Chip(
                  label: Text(result.status),
                  backgroundColor: result.status == 'PASS'
                      ? scheme.primary.withValues(alpha: 0.14)
                      : scheme.tertiary.withValues(alpha: 0.14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _MetricBlock(label: 'Score', value: '${result.percentage}%'),
                _MetricBlock(label: 'Correct', value: '${result.correct}'),
                _MetricBlock(label: 'Wrong', value: '${result.wrong}'),
                _MetricBlock(label: 'Skipped', value: '${result.skipped}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.point});

  final PerformancePoint point;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 36,
      height: 160,
      child: Column(
        children: [
          Text('${(point.value * 100).round()}%', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 18,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: point.value,
                  child: Container(
                    width: 18,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [scheme.primary, scheme.tertiary],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(point.label),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.score,
    required this.subtitle,
  });

  final int rank;
  final String name;
  final String score;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          child: Text('$rank'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(subtitle),
            ],
          ),
        ),
        Text(score, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
