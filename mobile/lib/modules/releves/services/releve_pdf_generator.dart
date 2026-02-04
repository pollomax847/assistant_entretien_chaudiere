import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:intl/intl.dart';
import '../../utils/mixins/pdf_generator_mixin.dart';

/// Générateur de PDF pour les relevés techniques avec photos intégrées
class ReleveTechniquePDFGenerator with PDFGeneratorMixin {
  final String nomEntreprise;
  final String nomTechnicien;
  final DateTime dateReleve;
  final String typeReleve;
  final Map<String, dynamic> donnees;
  final List<String> photoPaths;

  ReleveTechniquePDFGenerator({
    required this.nomEntreprise,
    required this.nomTechnicien,
    required this.dateReleve,
    required this.typeReleve,
    required this.donnees,
    this.photoPaths = const [],
  });

  /// Crée le PDF avec toutes les informations et photos
  Future<pw.Document> createPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => buildPDFHeader(
          title: typeReleve,
          entreprise: nomEntreprise,
          subtitle: 'Relevé du ${formatDate(dateReleve)}',
        ),
        footer: (context) => buildPDFFooter(context),
        build: (context) => [
          // --- SECTION INFOS GÉNÉRALES ---
          buildSection(
            title: 'Informations Générales',
            children: [
              buildInfoRow('Entreprise', nomEntreprise),
              buildInfoRow('Technicien', nomTechnicien),
              buildInfoRow('Date', formatDate(dateReleve)),
              buildInfoRow('Type', typeReleve),
            ],
          ),

          // --- SECTION DONNÉES TECHNIQUES ---
          if (donnees.isNotEmpty) ...[
            buildSection(
              title: 'Données Techniques',
              children: _buildDonneesSection(),
            ),
          ],

          // --- SECTION PHOTOS ---
          if (photoPaths.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            buildSection(
              title: 'Photographies du relevé',
              children: _buildPhotosSection(),
            ),
          ],
        ],
      ),
    );

    return pdf;
  }

  /// Construit la section des données techniques
  List<pw.Widget> _buildDonneesSection() {
    final widgets = <pw.Widget>[];

    donnees.forEach((key, value) {
      if (value is bool) {
        widgets.add(
          buildInfoRow(
            _formatKey(key),
            value ? 'Oui' : 'Non',
          ),
        );
      } else if (value is String && value.isNotEmpty) {
        widgets.add(
          buildInfoRow(_formatKey(key), value),
        );
      }
    });

    return widgets.isEmpty
        ? [pw.Text('Aucune donnée disponible')]
        : widgets;
  }

  /// Construit la section des photos
  List<pw.Widget> _buildPhotosSection() {
    final widgets = <pw.Widget>[];

    for (int i = 0; i < photoPaths.length; i++) {
      try {
        final file = File(photoPaths[i]);
        if (file.existsSync()) {
          widgets.addAll([
            pw.SizedBox(height: 10),
            pw.Text(
              'Photo ${i + 1}',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Image(
              pw.MemoryImage(file.readAsBytesSync()),
              width: 400,
              height: 300,
            ),
            pw.SizedBox(height: 15),
          ]);
        }
      } catch (e) {
        widgets.add(pw.Text('❌ Photo non disponible: ${photoPaths[i]}'));
      }
    }

    return widgets.isEmpty ? [pw.Text('Aucune photo')] : widgets;
  }

  /// Formate une clé pour l'affichage
  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}')
        .replaceFirst(' ', '')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Sauvegarde le PDF dans le dossier Documents
  Future<File> savePDF() async {
    final pdf = await createPDF();
    final fileName =
        'Releve_${typeReleve}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    // Sauvegarde dans /sdcard/Documents ou le dossier Download
    final path = '/sdcard/Documents/$fileName';
    final file = File(path);

    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
