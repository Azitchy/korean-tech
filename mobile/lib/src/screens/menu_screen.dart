import 'package:flutter/material.dart';

import '../widgets/section_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Menu', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Quick access to app tools and settings.'),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'Shortcuts',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(label: Text('Settings')),
                Chip(label: Text('Language')),
                Chip(label: Text('Dark Mode')),
                Chip(label: Text('Downloads')),
                Chip(label: Text('Certificates')),
                Chip(label: Text('Support')),
              ],
            ),
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
