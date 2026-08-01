import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../widgets/section_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Menu', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Quick access to app tools and settings.'),
          const SizedBox(height: 18),
          FutureBuilder(
            future: repo.loadMenuShortcuts(),
            builder: (context, snapshot) {
              final shortcuts = snapshot.data ?? const [];
              return SectionCard(
                title: 'Shortcuts',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: shortcuts.isEmpty
                      ? const [Chip(label: Text('No shortcuts published yet'))]
                      : shortcuts
                          .map(
                            (item) => Chip(
                              label: Text(item.title),
                            ),
                          )
                          .toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'Quick Actions',
            child: Column(
              children: [
                ListTile(leading: Icon(Icons.refresh_outlined), title: Text('Sync data')),
                ListTile(leading: Icon(Icons.security_outlined), title: Text('Security check')),
                ListTile(leading: Icon(Icons.logout_outlined), title: Text('Logout')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
