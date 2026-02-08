import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:intl/intl.dart';
import '../models/releve_technique.dart' as models;
import '../releve_technique_mapper.dart';

/// Générateur de PDF pour les relevés techniques avec photos intégrées
class ReleveTechniquePDFGenerator {
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

  /// Crée un générateur à partir d'un modèle structuré `ReleveTechnique`
  ReleveTechniquePDFGenerator.fromStructured(models.ReleveTechnique rt, {this.photoPaths = const []})
      : nomEntreprise = rt.client?.nom ?? '',
        nomTechnicien = rt.client?.nomTechnicien ?? '',
        dateReleve = rt.dateVisite ?? rt.dateCreation,
        typeReleve = rt.typeEquipement?.toString().split('.').last ?? 'Relevé',
        donnees = mapStructuredToFlat(rt);

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

  /// Construit l'en-tête du PDF
  pw.Widget buildPDFHeader({required String title, required String entreprise, required String subtitle}) {
    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.Text(entreprise, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
        pw.Text(subtitle, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.SizedBox(height: 12),
      ],
    );
  }

  /// Construit le pied de page du PDF
  pw.Widget buildPDFFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('Généré le ${formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 8)),
        pw.Text('Page ${context.pageNumber}/${context.pagesCount}', style: const pw.TextStyle(fontSize: 8)),
      ],
    );
  }

  /// Formate une date au format français
  String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'fr_FR');
    return formatter.format(date);
  }

  /// Construit une section avec titre et contenu
  pw.Widget buildSection({required String title, required List<pw.Widget> children}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        ...children,
        pw.SizedBox(height: 16),
      ],
    );
  }

  /// Construit une ligne info (clé: valeur)
  pw.Widget buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }
}
