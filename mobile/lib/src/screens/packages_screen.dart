import 'package:flutter/material.dart';

import '../data/mock_exam_repository.dart';
import '../models/app_models.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockExamRepository.instance;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Packages', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Compare access plans and premium features.'),
          const SizedBox(height: 18),
          FutureBuilder<List<PackagePlan>>(
            future: repo.loadPackages(),
            builder: (context, snapshot) {
              final packages = snapshot.data ?? const [];
              return Column(
                children: packages
                    .map(
                      (package) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _PackageTile(package: package),
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

class _PackageTile extends StatelessWidget {
  const _PackageTile({required this.package});

  final PackagePlan package;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: package.isFeatured
            ? scheme.primary.withValues(alpha: 0.10)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: package.isFeatured
              ? scheme.primary.withValues(alpha: 0.22)
              : scheme.outlineVariant.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(package.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${package.price} - ${package.duration}'),
                const SizedBox(height: 10),
                ...package.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: scheme.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (package.isFeatured)
            Chip(
              label: const Text('Popular'),
              backgroundColor: scheme.primary.withValues(alpha: 0.14),
              side: BorderSide.none,
            ),
        ],
      ),
    );
  }
}
