// new_project/lib/widgets/pdf_generator_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PDFGeneratorWidget extends StatelessWidget {
  final String title;
  final Future<File> Function() generatePDF;
  final String fileName;
  final bool allowPrinting;
  final bool allowSharing;
  final bool canChangePageFormat;
  final double maxPageWidth;
  final List<Widget>? actions;

  const PDFGeneratorWidget({
    Key? key,
    required this.title,
    required this.generatePDF,
    required this.fileName,
    this.allowPrinting = true,
    this.allowSharing = true,
    this.canChangePageFormat = false,
    this.maxPageWidth = 1000,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (allowPrinting)
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () => _printPDF(context),
            ),
          if (allowSharing)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _sharePDF(context),
            ),
          if (actions != null) ...actions!,
        ],
      ),
      body: PdfPreview(
        build: (format) async {
          final pdf = await generatePDF();
          return pdf.readAsBytesSync();
        },
        initialPageFormat: PdfPageFormat.a4,
        allowPrinting: allowPrinting,
        allowSharing: allowSharing,
        canChangePageFormat: canChangePageFormat,
        maxPageWidth: maxPageWidth,
      ),
    );
  }

  Future<void> _printPDF(BuildContext context) async {
    try {
      final pdf = await generatePDF();
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.readAsBytes(),
        name: fileName,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'impression: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sharePDF(BuildContext context) async {
    try {
      final pdf = await generatePDF();
      // TODO: Implémenter la logique de partage du PDF
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF généré avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la génération du PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
