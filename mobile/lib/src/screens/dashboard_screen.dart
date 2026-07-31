import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../navigation/app_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.onNavigate,
  });

  final ValueChanged<AppSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final repo = MockExamRepository.instance;
    const destinations = <AppSection>[
      AppSection.exams,
      AppSection.packages,
      AppSection.results,
      AppSection.leaderboard,
      AppSection.courses,
      AppSection.bookmarks,
      AppSection.streak,
      AppSection.notifications,
      AppSection.enquiries,
      AppSection.certificates,
    ];

    return FutureBuilder<List<SummaryStat>>(
      future: repo.loadStats(),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? const [];

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scheme.primary.withValues(alpha: 0.12),
                scheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _HeroHeader(scheme: scheme),
                const SizedBox(height: 18),
                GridView.builder(
                  itemCount: stats.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final stat = stats[index];
                    return _StatTile(
                      stat: stat,
                      onTap: () => onNavigate(destinations[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            scheme.tertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Student',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: scheme.onPrimary,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Prepare for IELTS, TOEFL, SAT and more with instant results, listening tests, and teacher support.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.88),
                ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: scheme.onPrimary,
              foregroundColor: scheme.primary,
            ),
            child: const Text('Start a practice test'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.stat,
    required this.onTap,
  });

  final SummaryStat stat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: stat.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: stat.accent.withValues(alpha: 0.20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(stat.icon, color: stat.accent),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stat.value, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(stat.label, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
