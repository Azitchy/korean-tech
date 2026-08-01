import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';

class ExamAttemptScreen extends StatefulWidget {
  const ExamAttemptScreen({super.key, required this.exam});

  final ExamCardData exam;

  @override
  State<ExamAttemptScreen> createState() => ExamAttemptScreenState();
}

class ExamAttemptScreenState extends State<ExamAttemptScreen> {
  late final Future<ExamDetailData> _detailFuture;
  final Map<int, int> _answers = {};
  int _currentIndex = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = MockExamRepository.instance.loadExamDetail(widget.exam.id);
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _next(ExamDetailData detail) {
    if (_currentIndex < detail.questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _submitted = true);
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _playQuestionSound() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing sample audio for this question.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExamDetailData>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _LoadingExam(title: widget.exam.title);
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.exam.title)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load exam questions.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final detail = snapshot.data;
        if (detail == null || detail.questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.exam.title)),
            body: const Center(child: Text('No questions have been published for this exam yet.')),
          );
        }

        if (_submitted) {
          return ExamResultScreen(
            exam: detail.exam,
            questions: detail.questions,
            answers: _answers,
            onBackToExams: () => Navigator.of(context).pop(),
          );
        }

        final question = detail.questions[_currentIndex];
        final progress = (_currentIndex + 1) / detail.questions.length;
        final selectedAnswer = _answers[_currentIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(detail.exam.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 12),
                  Text(
                    'Question ${_currentIndex + 1} of ${detail.questions.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          question.prompt,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: _playQuestionSound,
                        icon: const Icon(Icons.play_arrow_rounded),
                        tooltip: 'Play sound',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final option = question.options[index];
                        final isSelected = selectedAnswer == index;

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => _selectAnswer(index),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outlineVariant,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  child: Text(option.label),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(option.text)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentIndex == 0 ? null : _previous,
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: selectedAnswer == null ? null : () => _next(detail),
                          child: Text(_currentIndex == detail.questions.length - 1 ? 'Submit' : 'Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({
    super.key,
    required this.exam,
    required this.questions,
    required this.answers,
    required this.onBackToExams,
  });

  final ExamCardData exam;
  final List<ExamQuestionData> questions;
  final Map<int, int> answers;
  final VoidCallback onBackToExams;

  @override
  Widget build(BuildContext context) {
    final correct = answers.entries.where((entry) {
      return questions[entry.key].options[entry.value].isCorrect;
    }).length;
    final wrong = answers.length - correct;
    final skipped = questions.length - answers.length;
    final score = ((correct / questions.length) * exam.score).round();
    final pass = score >= (exam.score * 0.4).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(exam.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Text(
                      pass ? 'PASS' : 'FAIL',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: pass ? Colors.green : Colors.red,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Score: $score / ${exam.score}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _ResultRow(label: 'Total Questions', value: '${questions.length}'),
            _ResultRow(label: 'Correct Answers', value: '$correct'),
            _ResultRow(label: 'Wrong Answers', value: '$wrong'),
            _ResultRow(label: 'Unanswered', value: '$skipped'),
            _ResultRow(label: 'Percentage', value: '${((correct / questions.length) * 100).round()}%'),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onBackToExams,
              child: const Text('Back to Exams'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingExam extends StatelessWidget {
  const _LoadingExam({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
