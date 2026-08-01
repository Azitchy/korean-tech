import 'package:flutter/material.dart';

import 'app_models.dart';

class GalleryBook {
  const GalleryBook({
    required this.title,
    required this.author,
    required this.summary,
    required this.category,
    required this.pages,
    required this.assetPath,
    required this.accent,
  });

  factory GalleryBook.fromContentItem(ContentItemData item) {
    final metadata = item.metadata;
    return GalleryBook(
      title: item.title,
      author: item.subtitle ?? 'ExamVerse Studio',
      summary: item.body ?? '',
      category: metadata['category']?.toString() ?? 'General',
      pages: int.tryParse(metadata['pages']?.toString() ?? '') ?? 0,
      assetPath: metadata['asset_path']?.toString() ?? '',
      accent: _parseColor(metadata['accent']?.toString()),
    );
  }

  final String title;
  final String author;
  final String summary;
  final String category;
  final int pages;
  final String assetPath;
  final Color accent;
}

Color _parseColor(String? value) {
  if (value == null || value.isEmpty) {
    return const Color(0xFF5B8DEF);
  }

  final hex = value.replaceFirst('#', '');
  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  final parsed = int.tryParse(normalized, radix: 16);
  return parsed == null ? const Color(0xFF5B8DEF) : Color(parsed);
}
