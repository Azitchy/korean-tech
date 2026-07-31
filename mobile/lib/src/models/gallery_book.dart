import 'package:flutter/material.dart';

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

  final String title;
  final String author;
  final String summary;
  final String category;
  final int pages;
  final String assetPath;
  final Color accent;
}
