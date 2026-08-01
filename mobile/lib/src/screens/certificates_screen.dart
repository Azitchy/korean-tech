import 'package:flutter/material.dart';

import '../data/exam_repository.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Certificates', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Downloadable achievements published through the backend.'),
          const SizedBox(height: 18),
          FutureBuilder(
            future: repo.loadCertificates(),
            builder: (context, snapshot) {
              final certs = snapshot.data ?? const [];
              if (certs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('No certificates have been published yet.'),
                  ),
                );
              }

              return Column(
                children: certs
                    .map(
                      (cert) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.workspace_premium_outlined),
                          title: Text(cert.title),
                          subtitle: Text(cert.subtitle ?? cert.body ?? ''),
                          trailing: const Icon(Icons.download_outlined),
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
