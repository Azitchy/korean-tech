import 'package:flutter/material.dart';

import '../data/exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExamRepository.instance;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Notifications', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('All recent updates, reminders, replies, and promotions.'),
          const SizedBox(height: 18),
          FutureBuilder<List<DashboardNotification>>(
            future: repo.loadNotifications(),
            builder: (context, snapshot) {
              final notifications = snapshot.data ?? const [];
              return SectionCard(
                title: 'Latest Notifications',
                trailing: Text('Live', style: TextStyle(color: scheme.primary)),
                child: Column(
                  children: notifications
                      .map(
                        (note) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _NotificationTile(notification: note),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final DashboardNotification notification;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.type == 'reply' ? Icons.chat_bubble_outline : Icons.notifications_none,
            color: scheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text(notification.time, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Text(notification.body),
            ],
          ),
        ),
      ],
    );
  }
}
