import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final certs = const [
      'IELTS Mock Certificate - 84%',
      'TOEFL Practice Certificate - 76%',
      'SAT Mini Quiz Certificate - 91%',
      'Government Jobs Certificate - 88%',
      'University Entrance Certificate - 72%',
      'Language Course Certificate - 67%',
      'GRE Quant Certificate - 79%',
      'GMAT Data Certificate - 74%',
      'Banking Aptitude Certificate - 83%',
      'Daily Practice Badge - 91%',
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Certificates', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Downloadable achievements after passing or completing targets.'),
          const SizedBox(height: 18),
          ...certs.map(
            (cert) => Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(cert),
                trailing: const Icon(Icons.download_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
