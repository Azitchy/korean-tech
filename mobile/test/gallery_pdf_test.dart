import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:mobile/src/models/gallery_book.dart';
import 'package:mobile/src/screens/book_pdf_viewer_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sample PDF asset can be loaded and viewer screen builds', (tester) async {
    final data = await rootBundle.load('lib/src/assets/sample_book.pdf');
    expect(data.lengthInBytes, greaterThan(100));

    await tester.pumpWidget(
      MaterialApp(
        home: BookPdfViewerScreen(
          book: const GalleryBook(
            title: 'Test Book',
            author: 'Test Author',
            summary: 'Test summary',
            category: 'Test',
            pages: 12,
            assetPath: 'lib/src/assets/sample_book.pdf',
            accent: Colors.blue,
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Loading PDF'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(find.text('Could not load PDF'), findsNothing);
  });
}
