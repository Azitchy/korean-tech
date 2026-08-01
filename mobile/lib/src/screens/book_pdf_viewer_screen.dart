import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/gallery_book.dart';

class BookPdfViewerScreen extends StatefulWidget {
  const BookPdfViewerScreen({super.key, required this.book});

  final GalleryBook book;

  @override
  State<BookPdfViewerScreen> createState() => _BookPdfViewerScreenState();
}

class _BookPdfViewerScreenState extends State<BookPdfViewerScreen> {
  bool _isLoaded = false;
  PdfDocumentLoadFailedDetails? _loadFailedDetails;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        centerTitle: false,
        actions: [
          if (_isLoaded)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: Text('Read only')),
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.20),
                  ),
                ),
                child: widget.book.assetPath.isEmpty
                    ? const _StatePanel(
                        icon: Icons.picture_as_pdf_outlined,
                        title: 'No PDF attached',
                        message: 'This gallery item does not have an asset path yet.',
                      )
                    : _loadFailedDetails != null
                    ? _StatePanel(
                        icon: Icons.error_outline,
                        title: _loadFailedDetails!.error,
                        message: _loadFailedDetails!.description,
                      )
                    : SfPdfViewer.asset(
                        widget.book.assetPath,
                        canShowScrollHead: false,
                        canShowScrollStatus: false,
                        enableDocumentLinkAnnotation: false,
                        enableTextSelection: true,
                        onDocumentLoaded: (_) {
                          if (mounted && !_isLoaded) {
                            setState(() {
                              _isLoaded = true;
                            });
                          }
                        },
                        onDocumentLoadFailed: (details) {
                          if (mounted) {
                            setState(() {
                              _loadFailedDetails = details;
                            });
                          }
                        },
                      ),
              ),
            ),
            if (!_isLoaded && _loadFailedDetails == null)
              const Positioned.fill(
                child: _StatePanel(
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'Loading PDF',
                  message: 'Please wait while the PDF is prepared for reading.',
                  loading: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatePanel extends StatelessWidget {
  const _StatePanel({
    required this.icon,
    required this.title,
    required this.message,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: scheme.primary.withValues(alpha: 0.10),
                child: Icon(icon, color: scheme.primary, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              if (loading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
