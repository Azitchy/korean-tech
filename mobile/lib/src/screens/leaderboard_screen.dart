import 'package:flutter/material.dart';

import '../data/exam_repository.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Leaderboard', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Top performers based on backend-published ranking data.'),
          const SizedBox(height: 18),
          FutureBuilder(
            future: repo.loadLeaderboard(),
            builder: (context, snapshot) {
              final entries = snapshot.data ?? const [];
              if (entries.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No leaderboard data has been published yet.')),
                );
              }

              return Column(
                children: entries.asMap().entries.map((entry) {
                  final item = entry.value;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${item.rank}')),
                      title: Text(item.name),
                      subtitle: Text('Fastest completion: ${item.fastestCompletion}'),
                      trailing: Text('${item.score}'),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
