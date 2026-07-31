import 'package:flutter/material.dart';

import '../models/gallery_book.dart';
import 'book_pdf_viewer_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const List<GalleryBook> _books = [
    GalleryBook(
      title: 'Flutter Quick Start',
      author: 'ExamVerse Studio',
      summary: 'A beginner-friendly sample book for app onboarding and reading flow demo.',
      category: 'Programming',
      pages: 84,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF5B8DEF),
    ),
    GalleryBook(
      title: 'Practice Test Guide',
      author: 'ExamVerse Studio',
      summary: 'A short handbook that mirrors the exam preparation experience.',
      category: 'Study Guide',
      pages: 52,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF00A8A8),
    ),
    GalleryBook(
      title: 'Math Revision Notes',
      author: 'ExamVerse Studio',
      summary: 'Quick revision notes with a clean, readable layout for mobile viewing.',
      category: 'Revision',
      pages: 96,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFEB7D34),
    ),
    GalleryBook(
      title: 'Science Workbook',
      author: 'ExamVerse Studio',
      summary: 'A sample workbook used to demo book cover browsing and PDF preview.',
      category: 'Workbook',
      pages: 120,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF7B61FF),
    ),
    GalleryBook(
      title: 'English Grammar Tips',
      author: 'ExamVerse Studio',
      summary: 'Concise grammar examples with a document-style reading experience.',
      category: 'Language',
      pages: 68,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFE84D8A),
    ),
    GalleryBook(
      title: 'History Highlights',
      author: 'ExamVerse Studio',
      summary: 'A sample history book for testing vertical reading and zoom gestures.',
      category: 'Reference',
      pages: 74,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF3AAFA9),
    ),
    GalleryBook(
      title: 'Daily Quiz Planner',
      author: 'ExamVerse Studio',
      summary: 'Plan your daily preparation with this soft cover demo book.',
      category: 'Planner',
      pages: 40,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF3F51B5),
    ),
    GalleryBook(
      title: 'Admission Prep Notes',
      author: 'ExamVerse Studio',
      summary: 'A compact notes pack for admission test preparation and reading preview.',
      category: 'Notes',
      pages: 88,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFDA627D),
    ),
    GalleryBook(
      title: 'Computer Basics',
      author: 'ExamVerse Studio',
      summary: 'A visual sample for tech learners browsing books inside the gallery.',
      category: 'Technology',
      pages: 60,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF2A9D8F),
    ),
    GalleryBook(
      title: 'General Knowledge Deck',
      author: 'ExamVerse Studio',
      summary: 'A responsive book tile demo for a general knowledge PDF sample.',
      category: 'Knowledge',
      pages: 100,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFF4A261),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroBanner(onReadSample: () => _openBook(context, _books.first)),
          const SizedBox(height: 18),
          Text('Book Shelf', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          Text(
            'Browse 10 sample books and open any title in a read-only PDF viewer.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 750
                      ? 3
                      : constraints.maxWidth >= 420
                          ? 2
                          : 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 1 ? 1.22 : 0.92,
                ),
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return _BookCard(
                    book: book,
                    onTap: () => _openBook(context, book),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _openBook(BuildContext context, GalleryBook book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookPdfViewerScreen(book: book),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onReadSample});

  final VoidCallback onReadSample;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.95),
            scheme.tertiary.withValues(alpha: 0.90),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 580;

          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book Gallery',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Read sample PDFs right inside the app',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'The viewer is embedded without a download action, so users can read the file but stay inside the app experience.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onReadSample,
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('Read sample PDF'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: scheme.primary,
                ),
              ),
            ],
          );

          final artwork = Container(
            width: stacked ? double.infinity : 220,
            height: stacked ? 160 : 190,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Center(
              child: Icon(Icons.picture_as_pdf_outlined, color: Colors.white, size: 86),
            ),
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 18),
                artwork,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 20),
              artwork,
            ],
          );
        },
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book, required this.onTap});

  final GalleryBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: book.accent.withValues(alpha: 0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 122,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      book.accent.withValues(alpha: 0.95),
                      book.accent.withValues(alpha: 0.58),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.auto_stories_outlined,
                        size: 120,
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            book.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.description_outlined, size: 18, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text('${book.pages} pages'),
                        const Spacer(),
                        TextButton(
                          onPressed: onTap,
                          child: const Text('Open'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
