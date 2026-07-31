import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';
import 'exam_attempt_screen.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Exams', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Browse practice, mock, and live tests with exam timing and question counts.'),
          const SizedBox(height: 18),
          FutureBuilder<List<ExamCardData>>(
            future: repo.loadExams(),
            builder: (context, snapshot) {
              final exams = snapshot.data ?? const [];
              return Column(
                children: exams
                    .map(
                      (exam) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _ExamCard(exam: exam),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 4),
          const SectionCard(
            title: 'Module Coverage',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(label: Text('MCQ')),
                Chip(label: Text('Listening')),
                Chip(label: Text('Image Questions')),
                Chip(label: Text('Auto Save')),
                Chip(label: Text('Resume Exam')),
                Chip(label: Text('Random Options')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam});

  final ExamCardData exam;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exam.title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text('${exam.category} - ${exam.mode}'),
                    ],
                  ),
                ),
                if (exam.isLocked)
                  Icon(Icons.lock_outline, color: scheme.outline)
                else
                  Icon(Icons.play_circle_outline, color: scheme.primary),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(label: exam.duration, icon: Icons.timer_outlined),
                _InfoChip(label: '${exam.questions} questions', icon: Icons.help_outline),
                _InfoChip(label: '${exam.score} marks', icon: Icons.score_outlined),
              ],
            ),
            const SizedBox(height: 14),
            Text('Starts: ${exam.startsAt}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: exam.isLocked
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExamAttemptScreen(exam: exam),
                        ),
                      );
                    },
              child: Text(exam.isLocked ? 'Locked package' : 'Start now'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
