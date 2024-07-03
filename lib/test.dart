import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer_null_safe/flutter_full_pdf_viewer.dart';

class Test extends StatelessWidget {
  final String path;
  const Test({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      path: path,
    );
  }
}
