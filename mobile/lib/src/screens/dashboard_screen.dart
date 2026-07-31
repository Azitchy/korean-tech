import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final repo = MockExamRepository.instance;

    return FutureBuilder<List<Object?>>(
      future: Future.wait([
        repo.loadStats(),
        repo.loadNotifications(),
        repo.loadPackages(),
      ]),
      builder: (context, snapshot) {
        final stats = (snapshot.data?[0] as List?)?.cast<SummaryStat>() ?? const [];
        final notifications = (snapshot.data?[1] as List?)?.cast<DashboardNotification>() ?? const [];
        final packages = (snapshot.data?[2] as List?)?.cast<PackagePlan>() ?? const [];

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
                    return _StatTile(stat: stat);
                  },
                ),
                const SizedBox(height: 18),
                SectionCard(
                  title: 'Latest Notifications',
                  trailing: Text('Live', style: TextStyle(color: scheme.primary)),
                  child: Column(
                    children: notifications
                        .map(
                          (note) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _NotificationTile(notification: note),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 18),
                SectionCard(
                  title: 'Recommended Packages',
                  child: Column(
                    children: packages
                        .map(
                          (package) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _PackageTile(package: package),
                          ),
                        )
                        .toList(),
                  ),
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
  const _StatTile({required this.stat});

  final SummaryStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final DashboardNotification notification;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.type == 'reply' ? Icons.chat_bubble_outline : Icons.notifications_none,
            color: scheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text(notification.time, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Text(notification.body),
            ],
          ),
        ),
      ],
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({required this.package});

  final PackagePlan package;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: package.isFeatured ? scheme.primary.withValues(alpha: 0.10) : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: package.isFeatured ? scheme.primary.withValues(alpha: 0.22) : scheme.outlineVariant.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(package.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${package.price} • ${package.duration}'),
                const SizedBox(height: 10),
                ...package.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: scheme.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (package.isFeatured)
            Chip(
              label: const Text('Popular'),
              backgroundColor: scheme.primary.withValues(alpha: 0.14),
              side: BorderSide.none,
            ),
        ],
      ),
    );
  }
}
