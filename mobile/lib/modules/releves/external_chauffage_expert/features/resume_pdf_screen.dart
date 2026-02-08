// ChauffageExpert/lib/screens/resume_pdf_screen.dart
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ResumePdfScreen extends StatefulWidget {
  const ResumePdfScreen({super.key});

  @override
  State<ResumePdfScreen> createState() => _ResumePdfScreenState();
}

class _ResumePdfScreenState extends State<ResumePdfScreen> {
  bool _isGenerating = false;

  Future<void> _genererPdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdf = pw.Document();

      // En-tête
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData.withFont(
              base: pw.Font.helvetica(),
              bold: pw.Font.helveticaBold(),
            ),
          ),
          header: (context) => pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Chauffage Expert'),
                pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
              ],
            ),
          ),
          build: (context) => [
            // Informations client
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Informations Client',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Nom: Client Test'),
                  pw.Text('Adresse: 123 rue Test'),
                  pw.Text('Téléphone: 01 23 45 67 89'),
                ],
              ),
            ),

            // Informations équipement
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Informations Équipement',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Type: Chaudière'),
                  pw.Text('Marque: Test'),
                  pw.Text('Modèle: Test 123'),
                  pw.Text('Numéro de série: 123456'),
                ],
              ),
            ),

            // Mesures et vérifications
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Mesures et Vérifications',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Pression: 1.5 bar'),
                  pw.Text('Débit: 2.5 m³/h'),
                  pw.Text('Température: 65 °C'),
                  pw.Text('Rendement: 95 %'),
                ],
              ),
            ),

            // Non-conformités
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Non-conformités Détectées',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Aucune non-conformité détectée'),
                ],
              ),
            ),

            // Photos
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Photos',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Aucune photo disponible'),
                ],
              ),
            ),

            // Signatures
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Signatures',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text('Client'),
                          pw.Container(
                            width: 100,
                            height: 50,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text('Technicien'),
                          pw.Container(
                            width: 100,
                            height: 50,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text('Patron'),
                          pw.Container(
                            width: 100,
                            height: 50,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Clause de non-responsabilité
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Clause de Non-responsabilité',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'Ce rapport est établi conformément aux normes en vigueur. '
                    'Les mesures et observations sont effectuées avec le plus grand soin, '
                    'mais ne peuvent garantir l\'absence de tout risque. '
                    'Le client s\'engage à effectuer les travaux recommandés dans les délais indiqués.',
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      // Sauvegarder le PDF
      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/rapport_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Ouvrir le PDF
      await OpenFile.open(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rapport généré avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de la génération du rapport: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résumé & PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résumé du diagnostic',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text('Aucun diagnostic effectué'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actions recommandées',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text('Aucune action recommandée'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _genererPdf,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_isGenerating
                  ? 'Génération en cours...'
                  : 'Générer le rapport PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
