import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.tertiary],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person, size: 30)),
                const SizedBox(height: 16),
                Text('Nistha Shrestha', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: scheme.onPrimary)),
                const SizedBox(height: 4),
                Text('Student ID: ST-1024', style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.9))),
                const SizedBox(height: 8),
                Text('IELTS premium learner', style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.9))),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FutureBuilder<List<ProfileBadge>>(
            future: repo.loadBadges(),
            builder: (context, snapshot) {
              final badges = snapshot.data ?? const [];
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.bolt_outlined),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(badge.value, style: Theme.of(context).textTheme.titleLarge),
                              Text(badge.label),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'Account Settings',
            child: Column(
              children: [
                _SettingRow(icon: Icons.language_outlined, label: 'Language', value: 'English / नेपाली'),
                SizedBox(height: 10),
                _SettingRow(icon: Icons.dark_mode_outlined, label: 'Theme', value: 'System default'),
                SizedBox(height: 10),
                _SettingRow(icon: Icons.notifications_active_outlined, label: 'Push Notifications', value: 'Enabled'),
                SizedBox(height: 10),
                _SettingRow(icon: Icons.lock_outline, label: 'Security', value: 'PIN + OTP'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
