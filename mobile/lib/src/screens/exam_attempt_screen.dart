import 'package:flutter/material.dart';

import '../models/app_models.dart';

class ExamAttemptScreen extends StatefulWidget {
  const ExamAttemptScreen({super.key, required this.exam});

  final ExamCardData exam;

  @override
  State<ExamAttemptScreen> createState() => _ExamAttemptScreenState();
}

class _ExamAttemptScreenState extends State<ExamAttemptScreen> {
  late final List<_ExamQuestion> _questions;
  final Map<int, int> _answers = {};
  int _currentIndex = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildDummyQuestions(widget.exam);
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return ExamResultScreen(
        exam: widget.exam,
        questions: _questions,
        answers: _answers,
        onBackToExams: () => Navigator.of(context).pop(),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final selectedAnswer = _answers[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
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
                'Question ${_currentIndex + 1} of ${_questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 18),
              Text(
                question.prompt,
                style: Theme.of(context).textTheme.headlineSmall,
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
                      onPressed: selectedAnswer == null ? null : _next,
                      child: Text(_currentIndex == _questions.length - 1 ? 'Submit' : 'Next'),
                    ),
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

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({
    super.key,
    required this.exam,
    required this.questions,
    required this.answers,
    required this.onBackToExams,
  });

  final ExamCardData exam;
  final List<_ExamQuestion> questions;
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

class _ExamQuestion {
  const _ExamQuestion({
    required this.prompt,
    required this.options,
  });

  final String prompt;
  final List<_ExamOption> options;
}

class _ExamOption {
  const _ExamOption({
    required this.label,
    required this.text,
    required this.isCorrect,
  });

  final String label;
  final String text;
  final bool isCorrect;
}

List<_ExamQuestion> _buildDummyQuestions(ExamCardData exam) {
  return const [
    _ExamQuestion(
      prompt: '안녕하세요?',
      options: [
        _ExamOption(label: 'A', text: '안녕하세요.', isCorrect: true),
        _ExamOption(label: 'B', text: '감사합니다.', isCorrect: false),
        _ExamOption(label: 'C', text: '잘 가요.', isCorrect: false),
        _ExamOption(label: 'D', text: '실례합니다.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '이름이 뭐예요?',
      options: [
        _ExamOption(label: 'A', text: '제 이름은 민수예요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 네팔에서 왔어요.', isCorrect: false),
        _ExamOption(label: 'C', text: '오늘은 금요일이에요.', isCorrect: false),
        _ExamOption(label: 'D', text: '김치를 좋아해요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '어디에서 왔어요?',
      options: [
        _ExamOption(label: 'A', text: '저는 네팔에서 왔어요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 카트만두에 살아요.', isCorrect: false),
        _ExamOption(label: 'C', text: '제 취미는 음악 듣기예요.', isCorrect: false),
        _ExamOption(label: 'D', text: '한국어를 공부해요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '몇 살이에요?',
      options: [
        _ExamOption(label: 'A', text: '저는 스무 살이에요.', isCorrect: true),
        _ExamOption(label: 'B', text: '지금 세 시예요.', isCorrect: false),
        _ExamOption(label: 'C', text: '오늘은 금요일이에요.', isCorrect: false),
        _ExamOption(label: 'D', text: '네, 조금 할 수 있어요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '한국어를 할 수 있어요?',
      options: [
        _ExamOption(label: 'A', text: '네, 조금 할 수 있어요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 네팔에서 왔어요.', isCorrect: false),
        _ExamOption(label: 'C', text: '날씨가 좋아요.', isCorrect: false),
        _ExamOption(label: 'D', text: '학교에 다녀요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '지금 몇 시예요?',
      options: [
        _ExamOption(label: 'A', text: '지금 세 시예요.', isCorrect: true),
        _ExamOption(label: 'B', text: '오늘은 금요일이에요.', isCorrect: false),
        _ExamOption(label: 'C', text: '네, 좋아해요.', isCorrect: false),
        _ExamOption(label: 'D', text: '김치를 좋아해요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '오늘은 무슨 요일이에요?',
      options: [
        _ExamOption(label: 'A', text: '오늘은 금요일이에요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 스무 살이에요.', isCorrect: false),
        _ExamOption(label: 'C', text: '제 이름은 민수예요.', isCorrect: false),
        _ExamOption(label: 'D', text: '한국어를 공부해요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '좋아하는 음식이 뭐예요?',
      options: [
        _ExamOption(label: 'A', text: '김치를 좋아해요.', isCorrect: true),
        _ExamOption(label: 'B', text: '제 취미는 음악 듣기예요.', isCorrect: false),
        _ExamOption(label: 'C', text: '학교에 다녀요.', isCorrect: false),
        _ExamOption(label: 'D', text: '날씨가 좋아요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '취미가 뭐예요?',
      options: [
        _ExamOption(label: 'A', text: '제 취미는 음악 듣기예요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 카트만두에 살아요.', isCorrect: false),
        _ExamOption(label: 'C', text: '네, 조금 할 수 있어요.', isCorrect: false),
        _ExamOption(label: 'D', text: '지금 세 시예요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '학교에 다녀요?',
      options: [
        _ExamOption(label: 'A', text: '네, 학교에 다녀요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 스무 살이에요.', isCorrect: false),
        _ExamOption(label: 'C', text: '오늘은 금요일이에요.', isCorrect: false),
        _ExamOption(label: 'D', text: '김치를 좋아해요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '어디에 살아요?',
      options: [
        _ExamOption(label: 'A', text: '저는 카트만두에 살아요.', isCorrect: true),
        _ExamOption(label: 'B', text: '저는 네팔에서 왔어요.', isCorrect: false),
        _ExamOption(label: 'C', text: '학교에 다녀요.', isCorrect: false),
        _ExamOption(label: 'D', text: '안녕하세요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '날씨가 어때요?',
      options: [
        _ExamOption(label: 'A', text: '날씨가 좋아요.', isCorrect: true),
        _ExamOption(label: 'B', text: '제 이름은 민수예요.', isCorrect: false),
        _ExamOption(label: 'C', text: '지금 세 시예요.', isCorrect: false),
        _ExamOption(label: 'D', text: '네, 조금 할 수 있어요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '무엇을 공부해요?',
      options: [
        _ExamOption(label: 'A', text: '한국어를 공부해요.', isCorrect: true),
        _ExamOption(label: 'B', text: '김치를 좋아해요.', isCorrect: false),
        _ExamOption(label: 'C', text: '저는 스무 살이에요.', isCorrect: false),
        _ExamOption(label: 'D', text: '오늘은 금요일이에요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '커피를 좋아해요?',
      options: [
        _ExamOption(label: 'A', text: '네, 좋아해요.', isCorrect: true),
        _ExamOption(label: 'B', text: '안녕하세요.', isCorrect: false),
        _ExamOption(label: 'C', text: '학교에 다녀요.', isCorrect: false),
        _ExamOption(label: 'D', text: '저는 카트만두에 살아요.', isCorrect: false),
      ],
    ),
    _ExamQuestion(
      prompt: '만나서 반가워요.',
      options: [
        _ExamOption(label: 'A', text: '저도 만나서 반가워요.', isCorrect: true),
        _ExamOption(label: 'B', text: '날씨가 좋아요.', isCorrect: false),
        _ExamOption(label: 'C', text: '제 취미는 음악 듣기예요.', isCorrect: false),
        _ExamOption(label: 'D', text: '한국어를 공부해요.', isCorrect: false),
      ],
    ),
  ];
}
