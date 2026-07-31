import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = const [
      ('Aarav Shrestha', 98, '14:22'),
      ('Sita Karki', 95, '15:08'),
      ('Nabin Rai', 94, '15:41'),
      ('Mina Gurung', 93, '15:59'),
      ('Rohan Koirala', 92, '16:05'),
      ('Puja Shahi', 91, '16:18'),
      ('Dipesh Tamang', 90, '16:27'),
      ('Anita Rai', 89, '16:38'),
      ('Suman Adhikari', 88, '16:52'),
      ('Bikash Lama', 87, '17:01'),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Leaderboard', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Top performers based on score and completion time.'),
          const SizedBox(height: 18),
          ...entries.asMap().entries.map(
                (entry) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${entry.key + 1}')),
                    title: Text(entry.value.$1),
                    subtitle: Text('Fastest completion: ${entry.value.$3}'),
                    trailing: Text('${entry.value.$2}'),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
