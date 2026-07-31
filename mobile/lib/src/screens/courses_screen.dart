import 'package:flutter/material.dart';

import '../models/gallery_book.dart';
import 'book_pdf_viewer_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  static const List<GalleryBook> _coursePdfs = [
    GalleryBook(
      title: 'IELTS Foundation Course',
      author: 'ExamVerse Academy',
      summary: 'Beginner guide, lesson flow, and practice notes for IELTS preparation.',
      category: 'Beginner',
      pages: 120,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF4F7CAC),
    ),
    GalleryBook(
      title: 'TOEFL Speaking Booster',
      author: 'ExamVerse Academy',
      summary: 'Speaking drills, sample answers, and confidence-building templates.',
      category: 'Intermediate',
      pages: 84,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF5B8DEF),
    ),
    GalleryBook(
      title: 'SAT Core Math',
      author: 'ExamVerse Academy',
      summary: 'Core algebra, geometry, and problem-solving PDF lessons for SAT prep.',
      category: 'Advanced',
      pages: 96,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF00A8A8),
    ),
    GalleryBook(
      title: 'Government Jobs GK',
      author: 'ExamVerse Academy',
      summary: 'General knowledge booklet for public service exam preparation.',
      category: 'Beginner',
      pages: 110,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFEB7D34),
    ),
    GalleryBook(
      title: 'University Entrance Prep',
      author: 'ExamVerse Academy',
      summary: 'Entrance exam concepts, strategy notes, and quick revision pages.',
      category: 'Intermediate',
      pages: 140,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF7B61FF),
    ),
    GalleryBook(
      title: 'Language Basics',
      author: 'ExamVerse Academy',
      summary: 'Vocabulary, grammar, and reading basics in a compact PDF handout.',
      category: 'Beginner',
      pages: 72,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFE84D8A),
    ),
    GalleryBook(
      title: 'GRE Quant Sprint',
      author: 'ExamVerse Academy',
      summary: 'Fast-paced quantitative reasoning notes and practice examples.',
      category: 'Advanced',
      pages: 98,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF3AAFA9),
    ),
    GalleryBook(
      title: 'GMAT Data Insights',
      author: 'ExamVerse Academy',
      summary: 'Charts, logic, and analysis practice built for mobile reading.',
      category: 'Advanced',
      pages: 88,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFF3F51B5),
    ),
    GalleryBook(
      title: 'Banking Aptitude',
      author: 'ExamVerse Academy',
      summary: 'A full course book of aptitude topics, formulas, and practice tests.',
      category: 'Intermediate',
      pages: 104,
      assetPath: 'lib/src/assets/sample_book.pdf',
      accent: Color(0xFFDA627D),
    ),
    GalleryBook(
      title: 'Daily Practice Pack',
      author: 'ExamVerse Academy',
      summary: 'Mixed-difficulty daily reading pack for repeat practice and revision.',
      category: 'Mixed',
      pages: 160,
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
          Text('Courses', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Open any course PDF in a full-screen read-only viewer.',
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
                itemCount: _coursePdfs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 1 ? 1.22 : 0.92,
                ),
                itemBuilder: (context, index) {
                  final course = _coursePdfs[index];
                  return _CourseCard(
                    course: course,
                    onTap: () => _openCourse(context, course),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _openCourse(BuildContext context, GalleryBook course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookPdfViewerScreen(book: course),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course, required this.onTap});

  final GalleryBook course;
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
            border: Border.all(color: course.accent.withValues(alpha: 0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 122,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      course.accent.withValues(alpha: 0.95),
                      course.accent.withValues(alpha: 0.58),
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
                        Icons.menu_book_outlined,
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
                            course.category,
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
                      course.title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.author,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      course.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, size: 18, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text('${course.pages} pages'),
                        const Spacer(),
                        TextButton(
                          onPressed: onTap,
                          child: const Text('Read'),
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
