import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Bookmarks', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Saved questions and quick review references from the backend.'),
          const SizedBox(height: 18),
          FutureBuilder(
            future: repo.loadBookmarks(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('No bookmarks have been published yet.'),
                ));
              }

              return Column(
                children: items
                    .map(
                      (item) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.bookmark_outline),
                          title: Text(item.title),
                          subtitle: Text(item.subtitle ?? 'Saved for later review'),
                        ),
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
