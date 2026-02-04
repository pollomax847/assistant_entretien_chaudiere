import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void generateVmcPdf(
  BuildContext context,
  String vmcType,
  String housingType,
  Map<String, TextEditingController> controllers,
  Map<String, int> results,
  int totalFlow,
  int minimumFlow,
) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Rapport de calcul des débits VMC', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Type de VMC: $vmcType'),
            pw.Text('Type de logement: $housingType'),
            pw.SizedBox(height: 20),
            pw.Text('Nombre de pièces:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ...controllers.entries.map((entry) => pw.Text('${entry.key}: ${entry.value.text}')),
            pw.SizedBox(height: 20),
            pw.Text('Débits calculés:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ...results.entries.map((entry) => pw.Text('${entry.key}: ${entry.value} m³/h')),
            pw.Text('Débit total: $totalFlow m³/h'),
            pw.Text('Débit minimum réglementaire: $minimumFlow m³/h'),
            pw.Text(
              totalFlow >= minimumFlow ? 'Conforme à la réglementation' : 'Non conforme à la réglementation',
              style: pw.TextStyle(color: totalFlow >= minimumFlow ? PdfColors.green : PdfColors.red),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
