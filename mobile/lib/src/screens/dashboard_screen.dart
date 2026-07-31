import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../navigation/app_section.dart';
import 'exam_attempt_screen.dart';

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
      AppSection.gallery,
      AppSection.courses,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 600
                        ? 3
                        : constraints.maxWidth >= 380
                            ? 2
                            : 1;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    _HeroHeader(
                      scheme: scheme,
                      onStartPracticeTest: () => onNavigate(AppSection.exams),
                    ),
                    const SizedBox(height: 18),
                    GridView.builder(
                      itemCount: stats.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: columns == 1 ? 2.6 : 1.25,
                      ),
                      itemBuilder: (context, index) {
                        final stat = stats[index];
                        return _StatTile(
                          stat: stat,
                          onTap: () => onNavigate(destinations[index]),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _ExamPreviewSection(
                      onViewMore: () => onNavigate(AppSection.exams),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.scheme,
    required this.onStartPracticeTest,
  });

  final ColorScheme scheme;
  final VoidCallback onStartPracticeTest;

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
            onPressed: onStartPracticeTest,
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

class _ExamPreviewSection extends StatelessWidget {
  const _ExamPreviewSection({
    required this.onViewMore,
  });

  final VoidCallback onViewMore;

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return FutureBuilder<List<ExamCardData>>(
      future: repo.loadExams(),
      builder: (context, snapshot) {
        final exams = (snapshot.data ?? const <ExamCardData>[]).take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Practice Exams',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: onViewMore,
                  child: const Text('View more'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...exams.map(
              (exam) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                      child: const Icon(Icons.quiz_outlined),
                    ),
                    title: Text(exam.title),
                    subtitle: Text('${exam.category} - ${exam.duration} - ${exam.questions} questions'),
                    trailing: FilledButton(
                      onPressed: exam.isLocked
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ExamAttemptScreen(exam: exam),
                                ),
                              ),
                      child: Text(exam.isLocked ? 'Locked' : 'Start now'),
                    ),
                    onTap: exam.isLocked ? null : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ExamAttemptScreen(exam: exam),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
