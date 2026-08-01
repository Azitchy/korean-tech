import 'package:flutter/material.dart';

import '../data/exam_repository.dart';
import '../models/app_models.dart';
import 'exam_attempt_screen.dart';

class AudioPracticeScreen extends StatelessWidget {
  const AudioPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Audio Practice', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Practice listening-style exams with the same start now flow.'),
          const SizedBox(height: 18),
          FutureBuilder<List<ExamCardData>>(
            future: repo.loadAudioExams(),
            builder: (context, snapshot) {
              final exams = snapshot.data ?? const [];
              return Column(
                children: exams
                    .map(
                      (exam) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _AudioExamCard(exam: exam),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AudioExamCard extends StatelessWidget {
  const _AudioExamCard({required this.exam});

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
                Icon(Icons.graphic_eq_outlined, color: scheme.primary),
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
