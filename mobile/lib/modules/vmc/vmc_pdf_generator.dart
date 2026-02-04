import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:chauffageexpert/utils/app_utils.dart';
import 'vmc_calculator.dart';

class VMCPdfGenerator with PDFGeneratorMixin {
  // Singleton pattern
  VMCPdfGenerator._();
  static final VMCPdfGenerator instance = VMCPdfGenerator._();
  
  Future<void> generateDiagnosticReport({
    required BuildContext context,
    required String typeLogement,
    required String typeVMC,
    required List<Map<String, dynamic>> resultatsParPiece,
    required int pourcentageConformite,
    required String message,
    required String recommandation,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => buildPDFHeader(title: 'Rapport de Diagnostic VMC'),
        footer: (context) => buildPDFFooter(context),
        build: (pw.Context context) {
          return [
            // Informations générales
            buildSection(
              title: 'Informations générales',
              children: [
                buildInfoRow('Type de logement', typeLogement),
                buildInfoRow('Type de VMC', _getVMCLabel(typeVMC)),
                buildInfoRow('Date du diagnostic', formatDate(DateTime.now())),
              ],
            ),
            pw.SizedBox(height: 20),

            // Résultat global
            buildStatusCard(
              title: 'Résultat global',
              message: message,
              status: pourcentageConformite >= 80 ? 'success' : (pourcentageConformite >= 50 ? 'warning' : 'error'),
              percentage: '$pourcentageConformite%',
            ),
            pw.SizedBox(height: 20),

            // Tableau des résultats
            if (resultatsParPiece.isNotEmpty) ...[
              buildTable(
                headers: ['Pièce', 'Débit mesuré\n(m³/h)', 'Min\n(m³/h)', 'Max\n(m³/h)', 'État'],
                rows: resultatsParPiece.map((r) => [
                  r['nomPiece'] as String,
                  (r['debit'] as num).toStringAsFixed(1),
                  (r['min'] as num).toString(),
                  (r['max'] as num).toString(),
                  r['etat'] == 'success' ? '✓ Conforme' : '✗ Non conforme',
                ]).toList(),
              ),
            ],
            pw.SizedBox(height: 20),

            // Recommandations
            buildSection(
              title: 'Recommandations',
              backgroundColor: PdfColors.orange50,
              children: [
                pw.Text(
                  recommandation,
                  style: pw.TextStyle(fontSize: bodyFontSize),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  String _getVMCLabel(String typeVMC) {
    final types = VMCCalculator.getTypesVMC();
    final type = types.firstWhere(
      (t) => t['value'] == typeVMC,
      orElse: () => {'label': typeVMC},
    );
    return type['label'] ?? typeVMC;
  }
}
