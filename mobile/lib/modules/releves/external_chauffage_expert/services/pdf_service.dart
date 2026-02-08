// new_project/lib/services/pdf_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:chauffage_expert/models/releve_technique.dart';
import 'package:chauffage_expert/models/releve_vqs.dart';
import 'package:intl/intl.dart';
import '../models/calcul_puissance.dart';

class PDFService {
  static final PDFService _instance = PDFService._internal();
  factory PDFService() => _instance;
  PDFService._internal();

  static Future<File> genererPDFVQS(ReleveVQS releve) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Relevé VQS - ${releve.numero}'),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Date: ${releve.dateCreation.toLocal().toString().split('.')[0]}'),
              pw.Text('Adresse: ${releve.adresseIntervention}'),
              pw.SizedBox(height: 20),
              pw.Header(level: 1, child: pw.Text('Sections vérifiées')),
              ...releve.sections.entries.map((entry) {
                return pw.Row(
                  children: [
                    pw.Text(entry.key),
                    pw.SizedBox(width: 10),
                    pw.Text((entry.value as bool) ? '✓' : '✗'),
                  ],
                );
              }).toList(),
              if (releve.photos.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Header(level: 1, child: pw.Text('Photos')),
                pw.Wrap(
                  children: releve.photos.map((photo) {
                    return pw.Container(
                      width: 200,
                      height: 200,
                      child: pw.Image(
                        pw.MemoryImage(
                          File(photo.path).readAsBytesSync(),
                        ),
                        fit: pw.BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (releve.signatureClient != null) ...[
                pw.SizedBox(height: 20),
                pw.Header(level: 1, child: pw.Text('Signature du client')),
                pw.Image(
                  pw.MemoryImage(
                    File(releve.signatureClient!).readAsBytesSync(),
                  ),
                  width: 200,
                  height: 100,
                ),
              ],
              if (releve.signatureTechnicien != null) ...[
                pw.SizedBox(height: 20),
                pw.Header(level: 1, child: pw.Text('Signature du technicien')),
                pw.Image(
                  pw.MemoryImage(
                    File(releve.signatureTechnicien!).readAsBytesSync(),
                  ),
                  width: 200,
                  height: 100,
                ),
              ],
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/releve_${releve.numero}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> partagerPDF(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: 'Relevé VQS');
  }

  static Future<void> envoyerParEmail(File file, String email) async {
    // TODO: Implémenter l'envoi par email
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Relevé VQS',
    );
  }

  Future<File> generateRT({
    required RTType type,
    required ReleveTechnique releve,
  }) async {
    final pdf = pw.Document();
    final font = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();

    // En-tête
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 20),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 1, color: PdfColors.black),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Note de dimensionnement - Relevé Technique',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 18,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      _getSubtitle(type),
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 16,
                      ),
                    ),
                    if (type == RTType.pac) ...[
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Méthode de calcul selon Norme NF EN 15316',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                pw.Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(top: 20),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(width: 1, color: PdfColors.black),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Page ${context.pageNumber} / ${context.pagesCount}',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                  ),
                ),
                pw.Text(
                  'Memo Chaudière',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
        build: (context) => [
          _buildClientInfo(releve.toClientData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildInterventionInfo(releve.toClientData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildTechnicalInfo(releve.toTechnicalData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildEnvironmentInfo(releve.toTechnicalData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildEquipmentInfo(releve.toEquipmentData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildElectricalInfo(releve.toInstallationData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildClientWishes(releve.toClientData(), font, boldFont),
          pw.SizedBox(height: 20),
          _buildInstallationConfig(releve.toInstallationData(), font, boldFont),
          if (type == RTType.pac) ...[
            pw.SizedBox(height: 20),
            _buildDimensioning(releve.toTechnicalData(), font, boldFont),
          ],
          if (type == RTType.chaudiere) ...[
            pw.SizedBox(height: 20),
            _buildAccessories(releve.toEquipmentData(), font, boldFont),
          ],
        ],
      ),
    );

    // Annexes avec photos
    if (releve.photos.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 20),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1, color: PdfColors.black),
                ),
              ),
              child: pw.Text(
                'ANNEXE - PHOTOS',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 18,
                ),
              ),
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.only(top: 20),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(width: 1, color: PdfColors.black),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Page ${context.pageNumber} / ${context.pagesCount}',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 12,
                    ),
                  ),
                  pw.Text(
                    'Memo Chaudière',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
          build: (context) => releve.photos.map((photo) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Photo ${releve.photos.indexOf(photo) + 1}',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(photo.readAsBytesSync()),
                    height: 500,
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      );
    }

    // Sauvegarde du fichier
    final output = await getTemporaryDirectory();
    final file = File(
      '${output.path}/RT_${type.toString().split('.').last}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  String _getSubtitle(RTType type) {
    switch (type) {
      case RTType.pac:
        return 'RT PAC';
      case RTType.clim:
        return 'RT CLIMATISATION';
      case RTType.chaudiere:
        return 'RT CHAUDIÈRE';
    }
  }

  pw.Widget _buildClientInfo(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INFORMATIONS CLIENT',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('N° Client', data['clientNumber'] ?? '', font),
          _buildInfoRow('Nom', data['name'] ?? '', font),
          _buildInfoRow('Adresse', data['address'] ?? '', font),
          _buildInfoRow('Email', data['email'] ?? '', font),
          _buildInfoRow('Tél. Fixe', data['phone'] ?? '', font),
          _buildInfoRow('Mobile', data['mobile'] ?? '', font),
          pw.SizedBox(height: 10),
          pw.Text(
            'RÉSULTATS COMPTEUR',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Index début', data['startIndex'] ?? '', font),
          _buildInfoRow('Index fin', data['endIndex'] ?? '', font),
          _buildInfoRow(
              'Consommation', '${data['consumption'] ?? ''} kWh', font),
          _buildInfoRow('Période', data['period'] ?? '', font),
        ],
      ),
    );
  }

  pw.Widget _buildInterventionInfo(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INTERVENTION',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow(
              'Date intervention', data['interventionDate'] ?? '', font),
          _buildInfoRow(
              'Type intervention', data['interventionType'] ?? '', font),
          _buildInfoRow('Technicien', data['technician'] ?? '', font),
          _buildInfoRow('Durée', '${data['duration'] ?? ''} min', font),
          pw.SizedBox(height: 10),
          pw.Text(
            'Observations:',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 12,
            ),
          ),
          pw.Text(
            data['observations'] ?? '',
            style: pw.TextStyle(font: font),
          ),
          if (data['actions'] != null) ...[
            pw.SizedBox(height: 10),
            pw.Text(
              'Actions réalisées:',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 12,
              ),
            ),
            pw.Text(
              data['actions'] ?? '',
              style: pw.TextStyle(font: font),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value, pw.Font font) {
    return pw.Row(
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(
            label,
            style: pw.TextStyle(font: font),
          ),
        ),
        pw.Text(
          ': $value',
          style: pw.TextStyle(font: font),
        ),
      ],
    );
  }

  pw.Widget _buildTechnicalInfo(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DONNÉES TECHNIQUES',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Surface habitable', '${data['livingArea']} m²', font),
          _buildInfoRow(
              'Hauteur sous plafond', '${data['ceilingHeight']} m', font),
          _buildInfoRow('Volume chauffé', '${data['heatedVolume']} m³', font),
          _buildInfoRow(
              'Année de construction', data['constructionYear'] ?? '', font),
          _buildInfoRow(
              'Type de construction', data['constructionType'] ?? '', font),
          _buildInfoRow('Isolation', data['insulation'] ?? '', font),
        ],
      ),
    );
  }

  pw.Widget _buildEnvironmentInfo(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ENVIRONNEMENT',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Zone climatique', data['climateZone'] ?? '', font),
          _buildInfoRow('Altitude', '${data['altitude']} m', font),
          _buildInfoRow(
              'Température ext. base', '${data['baseExtTemp']} °C', font),
          _buildInfoRow('Température int. souhaitée',
              '${data['desiredIntTemp']} °C', font),
          _buildInfoRow('Exposition au vent', data['windExposure'] ?? '', font),
        ],
      ),
    );
  }

  pw.Widget _buildEquipmentInfo(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ÉQUIPEMENT',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Marque', data['brand'] ?? '', font),
          _buildInfoRow('Modèle', data['model'] ?? '', font),
          _buildInfoRow('Puissance', '${data['power']} kW', font),
          _buildInfoRow('Type d\'émetteurs', data['emitterType'] ?? '', font),
          _buildInfoRow('Régulation', data['regulation'] ?? '', font),
        ],
      ),
    );
  }

  pw.Widget _buildElectricalInfo(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INSTALLATION ÉLECTRIQUE',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow(
              'Type d\'alimentation', data['powerSupplyType'] ?? '', font),
          _buildInfoRow('Section câble', data['cableSection'] ?? '', font),
          _buildInfoRow('Protection', data['protection'] ?? '', font),
          _buildInfoRow('Disjoncteur', data['circuitBreaker'] ?? '', font),
        ],
      ),
    );
  }

  pw.Widget _buildClientWishes(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SOUHAITS CLIENT',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            data['wishes'] ?? '',
            style: pw.TextStyle(font: font),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInstallationConfig(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CONFIGURATION INSTALLATION',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Emplacement unité ext.',
              data['outdoorUnitLocation'] ?? '', font),
          _buildInfoRow('Distance unités', '${data['unitDistance']} m', font),
          _buildInfoRow('Dénivelé', '${data['heightDifference']} m', font),
          _buildInfoRow('Type liaison', data['connectionType'] ?? '', font),
        ],
      ),
    );
  }

  pw.Widget _buildDimensioning(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DIMENSIONNEMENT',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow(
              'Déperditions totales', '${data['totalLosses']} W', font),
          _buildInfoRow(
              'Coefficient G', '${data['gCoefficient']} W/m³.K', font),
          _buildInfoRow(
              'Puissance conseillée', '${data['recommendedPower']} kW', font),
        ],
      ),
    );
  }

  pw.Widget _buildAccessories(
      Map<String, dynamic> data, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ACCESSOIRES',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Type de conduit', data['ductType'] ?? '', font),
          _buildInfoRow('Diamètre', data['diameter'] ?? '', font),
          _buildInfoRow('Hauteur', '${data['height']} m', font),
          _buildInfoRow('Tubage', data['lining'] ?? '', font),
          _buildInfoRow('Ventouse', data['ventouse'] ?? '', font),
        ],
      ),
    );
  }

  Future<String> generatePuissancePdf(ResultatCalcul resultats) async {
    final pdf = pw.Document();

    // Ajout du contenu au PDF
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildHeader(),
          pw.SizedBox(height: 20),
          _buildResultats(resultats),
          pw.SizedBox(height: 20),
          _buildDetails(resultats),
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );

    // Sauvegarde du PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/calcul_puissance.pdf');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  pw.Widget _buildHeader() {
    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Calcul de Puissance de Chauffage',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Date: ${DateTime.now().toString().split(' ')[0]}',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildResultats(ResultatCalcul resultats) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Résultats du Calcul',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Puissance Totale: ${resultats.puissanceTotale.toStringAsFixed(2)} kW',
            style: const pw.TextStyle(fontSize: 14),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Puissance par Pièce:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          ...resultats.puissancesParPiece.map((piece) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20, top: 5),
                child: pw.Text(
                  '${piece.nom}: ${piece.puissance?.toStringAsFixed(2)} kW',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              )),
        ],
      ),
    );
  }

  pw.Widget _buildDetails(ResultatCalcul resultats) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Détails Techniques',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Coefficient G: ${resultats.coefficientG.toStringAsFixed(2)}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Text(
            'Delta T: ${resultats.deltaT.toStringAsFixed(2)}°C',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Footer(
      title: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes:',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            '• Les calculs sont basés sur la méthode de calcul standard',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            '• Les résultats sont donnés à titre indicatif',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            '• Consultez un professionnel pour une étude approfondie',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Future<void> genererPDFPuissance(
      List<Piece> pieces, double puissanceTotale, String adresse) async {
    final pdf = pw.Document();
    final font = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 20),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 1, color: PdfColors.black),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Calcul de puissance de chauffage',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 18,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Adresse: $adresse',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(top: 20),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(width: 1, color: PdfColors.black),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Page ${context.pageNumber} / ${context.pagesCount}',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                  ),
                ),
                pw.Text(
                  'Memo Chaudière',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Type de pièce',
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Surface (m²)',
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Hauteur (m)',
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Température (°C)',
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Puissance (kW)',
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                  ],
                ),
                ...pieces.map((piece) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child:
                            pw.Text(piece.typePiece.toString().split('.').last),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(piece.surface.toStringAsFixed(2)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(piece.hauteur.toStringAsFixed(2)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                            piece.temperatureSouhaitee.toStringAsFixed(1)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child:
                            pw.Text(piece.puissance?.toStringAsFixed(2) ?? '-'),
                      ),
                    ],
                  );
                }).toList(),
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Total',
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        puissanceTotale.toStringAsFixed(2),
                        style: pw.TextStyle(font: boldFont),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/calcul_puissance_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Calcul de puissance');
  }
}
