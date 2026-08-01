import 'package:flutter/material.dart';

import '../data/exam_repository.dart';
import '../models/app_models.dart';
import '../navigation/app_section.dart';
import 'exam_attempt_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.onNavigate});

  final ValueChanged<AppSection> onNavigate;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExamRepository _repo = ExamRepository.instance;
  late Future<DashboardSnapshot> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _repo.loadDashboard();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardFuture = _repo.loadDashboard();
    });
    await _dashboardFuture;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const destinations = <AppSection>[
      AppSection.profile,
      AppSection.courses,
      AppSection.courses,
      AppSection.courses,
      AppSection.packages,
      AppSection.exams,
      AppSection.enquiries,
      AppSection.menu,
      AppSection.exams,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [scheme.primary.withValues(alpha: 0.12), scheme.surface],
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<DashboardSnapshot>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            final dashboard = snapshot.data;
            final stats = dashboard == null
                ? const <SummaryStat>[]
                : _buildStats(dashboard);
            final categories =
                dashboard?.categories ?? const <CategorySummaryData>[];
            final upcomingExams =
                dashboard?.upcomingExams ?? const <ExamCardData>[];
            final packages =
                dashboard?.featuredPackages ?? const <PackagePlan>[];
            final sections =
                dashboard?.sections ?? const <DashboardSectionSummary>[];

            return RefreshIndicator(
              onRefresh: _refreshDashboard,
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      _HeroHeader(
                        scheme: scheme,
                        onStartPracticeTest: () =>
                            widget.onNavigate(AppSection.exams),
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
                            onTap: () => widget.onNavigate(destinations[index]),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _SectionHeader(
                        title: 'Categories from Admin',
                        actionLabel: 'View courses',
                        onTap: () => widget.onNavigate(AppSection.courses),
                      ),
                      const SizedBox(height: 10),
                      _CategoryStrip(categories: categories),
                      const SizedBox(height: 20),
                      _ExamPreviewSection(
                        title: 'Upcoming Exams',
                        exams: upcomingExams,
                        onViewMore: () => widget.onNavigate(AppSection.exams),
                      ),
                      const SizedBox(height: 20),
                      _PackagePreviewSection(
                        packages: packages,
                        onViewMore: () =>
                            widget.onNavigate(AppSection.packages),
                      ),
                      const SizedBox(height: 20),
                      _SectionCoverageCard(sections: sections),
                      const SizedBox(height: 20),
                      _AudioPracticeSection(
                        onViewMore: () =>
                            widget.onNavigate(AppSection.audioPractice),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  List<SummaryStat> _buildStats(DashboardSnapshot dashboard) {
    final summary = dashboard.summary;
    return [
      SummaryStat(
        label: 'Users',
        value: '${summary['users'] ?? 0}',
        icon: Icons.people_outline,
        accent: const Color(0xFF0EA5A4),
      ),
      SummaryStat(
        label: 'Categories',
        value: '${summary['categories'] ?? 0}',
        icon: Icons.layers_outlined,
        accent: const Color(0xFFF97316),
      ),
      SummaryStat(
        label: 'Subjects',
        value: '${summary['subjects'] ?? 0}',
        icon: Icons.book_outlined,
        accent: const Color(0xFF14B8A6),
      ),
      SummaryStat(
        label: 'Courses',
        value: '${summary['courses'] ?? 0}',
        icon: Icons.menu_book,
        accent: const Color(0xFF6366F1),
      ),
      SummaryStat(
        label: 'Packages',
        value: '${summary['packages'] ?? 0}',
        icon: Icons.workspace_premium,
        accent: const Color(0xFFF97316),
      ),
      SummaryStat(
        label: 'Exams',
        value: '${summary['exams'] ?? 0}',
        icon: Icons.assignment_turned_in,
        accent: const Color(0xFF0EA5A4),
      ),
      SummaryStat(
        label: 'Enquiries',
        value: '${summary['enquiries'] ?? 0}',
        icon: Icons.forum_outlined,
        accent: const Color(0xFFEC4899),
      ),
      SummaryStat(
        label: 'Mobile Items',
        value: '${summary['mobile_items'] ?? 0}',
        icon: Icons.phone_android_outlined,
        accent: const Color(0xFF14B8A6),
      ),
      SummaryStat(
        label: 'Today\'s Exams',
        value: '${summary['todays_exams'] ?? 0}',
        icon: Icons.today_outlined,
        accent: const Color(0xFF8B5CF6),
      ),
    ];
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.scheme, required this.onStartPracticeTest});

  final ColorScheme scheme;
  final VoidCallback onStartPracticeTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [scheme.primary, scheme.tertiary]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Student',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: scheme.onPrimary),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.categories});

  final List<CategorySummaryData> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('No categories have been published yet.'),
      );
    }

    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.50),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.layers_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('${category.courseCount} courses'),
                      side: BorderSide.none,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description.isEmpty
                          ? 'Admin-managed category'
                          : category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExamPreviewSection extends StatelessWidget {
  const _ExamPreviewSection({
    required this.title,
    required this.exams,
    required this.onViewMore,
  });

  final String title;
  final List<ExamCardData> exams;
  final VoidCallback onViewMore;

  @override
  Widget build(BuildContext context) {
    final visibleExams = exams.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            TextButton(onPressed: onViewMore, child: const Text('View more')),
          ],
        ),
        const SizedBox(height: 10),
        if (visibleExams.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No exam data has been published yet.'),
          )
        else
          ...visibleExams.map(
            (exam) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    child: const Icon(Icons.quiz_outlined),
                  ),
                  title: Text(exam.title),
                  subtitle: Text(
                    '${exam.category} - ${exam.duration} - ${exam.questions} questions',
                  ),
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
                  onTap: exam.isLocked
                      ? null
                      : () => Navigator.of(context).push(
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
  }
}

class _AudioPracticeSection extends StatelessWidget {
  const _AudioPracticeSection({required this.onViewMore});

  final VoidCallback onViewMore;

  @override
  Widget build(BuildContext context) {
    final repo = ExamRepository.instance;

    return FutureBuilder<List<ExamCardData>>(
      future: repo.loadAudioExams(),
      builder: (context, snapshot) {
        final exams = (snapshot.data ?? const <ExamCardData>[])
            .take(4)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Audio Practice',
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.12),
                      child: const Icon(Icons.graphic_eq_outlined),
                    ),
                    title: Text(exam.title),
                    subtitle: Text(
                      '${exam.category} - ${exam.duration} - ${exam.questions} questions',
                    ),
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
                    onTap: exam.isLocked
                        ? null
                        : () => Navigator.of(context).push(
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

class _PackagePreviewSection extends StatelessWidget {
  const _PackagePreviewSection({
    required this.packages,
    required this.onViewMore,
  });

  final List<PackagePlan> packages;
  final VoidCallback onViewMore;

  @override
  Widget build(BuildContext context) {
    final visiblePackages = packages.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Featured Packages',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(onPressed: onViewMore, child: const Text('View more')),
          ],
        ),
        const SizedBox(height: 10),
        if (visiblePackages.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No packages have been published yet.'),
          )
        else
          ...visiblePackages.map(
            (package) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PackageTile(package: package),
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
        color: package.isFeatured
            ? scheme.primary.withValues(alpha: 0.10)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: package.isFeatured
              ? scheme.primary.withValues(alpha: 0.22)
              : scheme.outlineVariant.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text('${package.price} - ${package.duration}'),
                const SizedBox(height: 10),
                ...package.features
                    .take(4)
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: scheme.primary,
                            ),
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

class _SectionCoverageCard extends StatelessWidget {
  const _SectionCoverageCard({required this.sections});

  final List<DashboardSectionSummary> sections;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Section Coverage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'Content items published in the admin dashboard are grouped here.',
            ),
            const SizedBox(height: 14),
            if (sections.isEmpty)
              const Text('No content sections have been published yet.')
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: sections
                    .map(
                      (section) => Chip(
                        label: Text('${section.section} (${section.total})'),
                        avatar: const Icon(Icons.widgets_outlined, size: 18),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat, required this.onTap});

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
                  Text(
                    stat.value,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
