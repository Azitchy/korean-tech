import 'package:flutter/material.dart';

import '../data/exam_repository.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class EnquiriesScreen extends StatefulWidget {
  const EnquiriesScreen({super.key});

  @override
  State<EnquiriesScreen> createState() => _EnquiriesScreenState();
}

class _EnquiriesScreenState extends State<EnquiriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _repo = ExamRepository.instance;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEnquiry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _repo.submitEnquiry(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enquiry sent successfully.')),
      );
      _subjectController.clear();
      _messageController.clear();
      setState(() {});
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send enquiry: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Enquiries', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Ask teachers questions and follow the reply history.'),
          const SizedBox(height: 18),
          FutureBuilder<List<EnquiryThread>>(
            future: _repo.loadEnquiries(),
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
          SectionCard(
            title: 'Ask a Teacher',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Enter your email';
                      if (!text.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter a subject' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter a message' : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _sendEnquiry,
                      child: Text(_isSubmitting ? 'Sending...' : 'Send enquiry'),
                    ),
                  ),
                ],
              ),
            ),
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
                  backgroundColor: thread.status.toLowerCase() == 'solved'
                      ? scheme.primary.withValues(alpha: 0.14)
                      : scheme.secondary.withValues(alpha: 0.14),
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
