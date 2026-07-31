import 'package:flutter/material.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      'IELTS Listening Question 3',
      'TOEFL Reading Passage 5',
      'SAT Math Formula Sheet',
      'Government GK Quiz 01',
      'University Math Notes',
      'Language Vocabulary Drill',
      'GRE Quant Shortcut',
      'GMAT Logic Puzzle',
      'Banking Reasoning Trick',
      'Daily Practice Question 14',
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Bookmarks', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Saved questions for quick review and practice again.'),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: Text(item),
                subtitle: const Text('Saved for later review'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
