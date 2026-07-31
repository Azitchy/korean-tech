import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class EnquiriesScreen extends StatelessWidget {
  const EnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Enquiries', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Ask teachers questions and follow the reply history.'),
          const SizedBox(height: 18),
          FutureBuilder<List<EnquiryThread>>(
            future: repo.loadEnquiries(),
            builder: (context, snapshot) {
              final enquiries = snapshot.data ?? const [];
              return Column(
                children: enquiries
                    .map(
                      (thread) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _ThreadCard(thread: thread),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SectionCard(
            title: 'Ask a Teacher',
            child: _QuickMessageForm(),
          ),
        ],
      ),
    );
  }
}

class _ThreadCard extends StatelessWidget {
  const _ThreadCard({required this.thread});

  final EnquiryThread thread;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(thread.subject, style: Theme.of(context).textTheme.titleLarge),
                ),
                Chip(
                  label: Text(thread.status),
                  backgroundColor: thread.status == 'Answered'
                      ? scheme.primary.withOpacity(0.14)
                      : scheme.secondary.withOpacity(0.14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${thread.category} • ${thread.updatedAt}'),
            const SizedBox(height: 12),
            Text(thread.lastMessage),
          ],
        ),
      ),
    );
  }
}

class _QuickMessageForm extends StatelessWidget {
  const _QuickMessageForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {},
            child: const Text('Send enquiry'),
          ),
        ),
      ],
    );
  }
}
