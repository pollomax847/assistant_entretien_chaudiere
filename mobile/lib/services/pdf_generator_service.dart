import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class PdfGeneratorService {
  static const String _companyName = 'Chauffage Expert';
  static const String _companySlogan = 'Solutions de chauffage professionnelles';

  // Couleurs du thème
  static const PdfColor _primaryColor = PdfColor(0.2, 0.4, 0.8); // Bleu
  static const PdfColor _secondaryColor = PdfColor(0.8, 0.2, 0.2); // Rouge
  static const PdfColor _accentColor = PdfColor(0.2, 0.8, 0.4); // Vert
  static const PdfColor _textColor = PdfColor(0.2, 0.2, 0.2); // Gris foncé
  static const PdfColor _lightGray = PdfColor(0.9, 0.9, 0.9); // Gris clair

  // Méthodes utilitaires pour construire le PDF
  static pw.Widget _buildHeader(String title) {
    return pw.Column(
      children: [
        pw.Text(
          'Assistant Entretien Chaudière',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  static pw.Widget _buildInfoTable(List<List<String>> data) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: data.map((row) => pw.TableRow(
        children: row.map((cell) => pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            cell,
            style: const pw.TextStyle(fontSize: 12),
          ),
        )).toList(),
      )).toList(),
    );
  }

  static pw.Widget _buildResultsTable(List<List<String>> data) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: data.map((row) => pw.TableRow(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              row[0],
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(row[1]),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              row[2],
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        ],
      )).toList(),
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 12)),
    );
  }

  static pw.Widget _buildControleTable(List<List<dynamic>> data) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: data.map((row) => pw.TableRow(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              row[0] as String,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Icon(
              row[1] as bool ? pw.IconData(0xe5ca) : pw.IconData(0xe5cd), // check_circle or cancel
              color: row[1] as bool ? PdfColors.green : PdfColors.red,
              size: 16,
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              row[2] as String,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      )).toList(),
    );
  }

  static pw.Widget _buildDistanceTable(Map<String, dynamic> controles) {
    final distances = [
      ['Appareil gaz - matériaux combustibles', controles['distanceCombustibles'], '30 cm'],
      ['Appareil gaz - matériaux non combustibles', controles['distanceNonCombustibles'], '10 cm'],
      ['Tuyau évacuation - matériaux combustibles', controles['distanceTuyauCombustibles'], '5 cm'],
      ['Tuyau évacuation - matériaux non combustibles', controles['distanceTuyauNonCombustibles'], '2 cm'],
    ];

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: distances.map((row) => pw.TableRow(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              row[0] as String,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              '${row[1]} cm',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              row[2] as String,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Icon(
              (row[1] as double) >= double.parse((row[2] as String).split(' ')[0])
                ? pw.IconData(0xe5ca) : pw.IconData(0xe5cd),
              color: (row[1] as double) >= double.parse((row[2] as String).split(' ')[0])
                ? PdfColors.green : PdfColors.red,
              size: 16,
            ),
          ),
        ],
      )).toList(),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Rapport généré automatiquement par Assistant Entretien Chaudière',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Date de génération: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Future<File> _saveAndSharePdf(pw.Document pdf, String fileName) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
  // Méthodes statiques pour générer les PDFs

  static Future<File> generateTestGazPdf({
    required String technicien,
    required String entreprise,
    required DateTime dateTest,
    required String typeGaz,
    required double pcsGaz,
    required double indexDebut,
    required double indexFin,
    required double dureeSecondes,
    required double consommation,
    required double debitHoraire,
    required double puissanceBrute,
    required double puissanceNette,
    required double rendement,
    required String typeAppareil,
    required String evaluation,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // En-tête
          _buildHeader('Rapport de Test Compteur Gaz'),

          pw.SizedBox(height: 20),

          // Informations générales
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du test', DateFormat('dd/MM/yyyy HH:mm').format(dateTest)],
            ['Type de gaz', '$typeGaz (${pcsGaz.toStringAsFixed(1)} kWh/m³)'],
          ]),

          pw.SizedBox(height: 20),

          // Paramètres du test
          _buildSectionTitle('Paramètres du Test'),
          _buildInfoTable([
            ['Index de départ', '${indexDebut.toStringAsFixed(3)} m³'],
            ['Index de fin', '${indexFin.toStringAsFixed(3)} m³'],
            ['Durée du test', '${dureeSecondes.toStringAsFixed(1)} secondes'],
            ['Rendement appliqué', '${(rendement * 100).toStringAsFixed(0)}%'],
          ]),

          pw.SizedBox(height: 20),

          // Résultats
          _buildSectionTitle('Résultats du Test'),
          _buildResultsTable([
            ['Consommation', '${consommation.toStringAsFixed(3)} m³', ''],
            ['Débit horaire', '${debitHoraire.toStringAsFixed(2)} m³/h', ''],
            ['Puissance brute', '${puissanceBrute.toStringAsFixed(1)} kW', ''],
            ['Puissance nette', '${puissanceNette.toStringAsFixed(1)} kW', '(avec rendement)'],
            ['Type d\'appareil', typeAppareil, ''],
          ]),

          pw.SizedBox(height: 20),

          // Évaluation
          _buildSectionTitle('Évaluation'),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: evaluation.contains('✅') ? PdfColor(0.8, 1.0, 0.8) :
                     evaluation.contains('⚠️') ? PdfColor(1.0, 0.9, 0.7) :
                     PdfColor(1.0, 0.8, 0.8),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              evaluation,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: _textColor,
              ),
            ),
          ),

          // Observations
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations'),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGray,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                observations,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Pied de page
          _buildFooter(),
        ],
      ),
    );

    return await _saveAndSharePdf(pdf, 'rapport_test_gaz_${DateFormat('yyyyMMdd_HHmm').format(dateTest)}.pdf');
  }

  /// Génère un PDF pour le module ECS
  static Future<File> generateEcsPdf({
    required String technicien,
    required String entreprise,
    required DateTime dateCalcul,
    required List<Map<String, dynamic>> equipements,
    required double debitTotal,
    required double puissanceTotale,
    required double temperatureEauFroide,
    required double temperatureEcs,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // En-tête
          _buildHeader('Rapport de Calcul ECS'),

          pw.SizedBox(height: 20),

          // Informations générales
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du calcul', DateFormat('dd/MM/yyyy HH:mm').format(dateCalcul)],
          ]),

          pw.SizedBox(height: 20),

          // Paramètres de calcul
          _buildSectionTitle('Paramètres de Calcul'),
          _buildInfoTable([
            ['Température eau froide', '${temperatureEauFroide.toStringAsFixed(1)}°C'],
            ['Température ECS souhaitée', '${temperatureEcs.toStringAsFixed(1)}°C'],
            ['Écart de température', '${(temperatureEcs - temperatureEauFroide).toStringAsFixed(1)}°C'],
          ]),

          pw.SizedBox(height: 20),

          // Équipements
          _buildSectionTitle('Équipements'),
          pw.Table(
            border: pw.TableBorder.all(color: _lightGray),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: _primaryColor),
                children: [
                  _buildTableHeader('Équipement'),
                  _buildTableHeader('Débit (L/min)'),
                  _buildTableHeader('Coefficient'),
                  _buildTableHeader('Débit simultané (L/min)'),
                ],
              ),
              ...equipements.map((equipement) => pw.TableRow(
                children: [
                  _buildTableCell(equipement['nom']),
                  _buildTableCell(equipement['debit'].toStringAsFixed(1)),
                  _buildTableCell(equipement['coefficient'].toStringAsFixed(2)),
                  _buildTableCell(equipement['debitSimultane'].toStringAsFixed(1)),
                ],
              )),
            ],
          ),

          pw.SizedBox(height: 20),

          // Résultats
          _buildSectionTitle('Résultats'),
          _buildResultsTable([
            ['Débit total simultané', '${debitTotal.toStringAsFixed(1)} L/min', ''],
            ['Puissance totale requise', '${puissanceTotale.toStringAsFixed(1)} kW', ''],
          ]),

          // Observations
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations'),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGray,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                observations,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Pied de page
          _buildFooter(),
        ],
      ),
    );

    return await _saveAndSharePdf(pdf, 'rapport_ecs_${DateFormat('yyyyMMdd_HHmm').format(dateCalcul)}.pdf');
  }

  /// Génère un PDF pour le module Vase d'Expansion
  static Future<File> generateVaseExpansionPdf({
    required String technicien,
    required String entreprise,
    required DateTime dateCalcul,
    required double hauteurInstallation,
    required double pressionCalculee,
    required String recommandation,
    required bool conforme,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // En-tête
          _buildHeader('Rapport de Calcul Vase d\'Expansion'),

          pw.SizedBox(height: 20),

          // Informations générales
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du calcul', DateFormat('dd/MM/yyyy HH:mm').format(dateCalcul)],
          ]),

          pw.SizedBox(height: 20),

          // Calcul
          _buildSectionTitle('Calcul de Pression'),
          _buildInfoTable([
            ['Hauteur d\'installation', '${hauteurInstallation.toStringAsFixed(1)} mètres'],
            ['Formule appliquée', 'Pression = (Hauteur ÷ 10) + 0.3 bar'],
            ['Pression calculée', '${pressionCalculee.toStringAsFixed(2)} bar'],
          ]),

          pw.SizedBox(height: 20),

          // Recommandation
          _buildSectionTitle('Recommandation'),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: conforme ? PdfColor(0.8, 1.0, 0.8) : PdfColor(1.0, 0.9, 0.7),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  conforme ? '✅ CONFORME' : '⚠️ ATTENTION REQUISE',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: conforme ? PdfColor(0.2, 0.6, 0.2) : PdfColor(0.8, 0.4, 0.0),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  recommandation,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // Observations
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations'),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGray,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                observations,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Pied de page
          _buildFooter(),
        ],
      ),
    );

    return await _saveAndSharePdf(pdf, 'rapport_vase_expansion_${DateFormat('yyyyMMdd_HHmm').format(dateCalcul)}.pdf');
  }

  /// Génère un PDF pour le module Équilibrage
  static Future<File> generateEquilibragePdf({
    required String technicien,
    required String entreprise,
    required DateTime dateCalcul,
    required String typeCircuit,
    required List<Map<String, dynamic>> circuits,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // En-tête
          _buildHeader('Rapport d\'Équilibrage'),

          pw.SizedBox(height: 20),

          // Informations générales
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du calcul', DateFormat('dd/MM/yyyy HH:mm').format(dateCalcul)],
            ['Type de circuit', typeCircuit],
          ]),

          pw.SizedBox(height: 20),

          // Circuits
          _buildSectionTitle('Circuits Calculés'),
          if (typeCircuit == 'Radiateurs') ...[
            pw.Table(
              border: pw.TableBorder.all(color: _lightGray),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: _primaryColor),
                  children: [
                    _buildTableHeader('Circuit'),
                    _buildTableHeader('Puissance (W)'),
                    _buildTableHeader('ΔT (°C)'),
                    _buildTableHeader('Débit (L/h)'),
                  ],
                ),
                ...circuits.map((circuit) => pw.TableRow(
                  children: [
                    _buildTableCell(circuit['nom']),
                    _buildTableCell(circuit['puissance'].toStringAsFixed(0)),
                    _buildTableCell(circuit['deltaT'].toStringAsFixed(1)),
                    _buildTableCell(circuit['debit'].toStringAsFixed(0)),
                  ],
                )),
              ],
            ),
          ] else ...[
            pw.Table(
              border: pw.TableBorder.all(color: _lightGray),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: _primaryColor),
                  children: [
                    _buildTableHeader('Circuit'),
                    _buildTableHeader('Longueur (m)'),
                    _buildTableHeader('Débit (L/h)'),
                    _buildTableHeader('Pertes (mbar)'),
                  ],
                ),
                ...circuits.map((circuit) => pw.TableRow(
                  children: [
                    _buildTableCell(circuit['nom']),
                    _buildTableCell(circuit['longueur'].toStringAsFixed(1)),
                    _buildTableCell(circuit['debit'].toStringAsFixed(0)),
                    _buildTableCell(circuit['pertes'].toStringAsFixed(1)),
                  ],
                )),
              ],
            ),
          ],

          // Observations
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations'),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGray,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                observations,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Pied de page
          _buildFooter(),
        ],
      ),
    );

    return await _saveAndSharePdf(pdf, 'rapport_equilibrage_${DateFormat('yyyyMMdd_HHmm').format(dateCalcul)}.pdf');
  }

  /// Génère un PDF pour le module Réglementation Gaz
  static Future<File> generateReglementationGazPdf({
    required String technicien,
    required String entreprise,
    required DateTime dateControle,
    required Map<String, dynamic> controles,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // En-tête
          _buildHeader('Rapport de Contrôle Réglementation Gaz'),

          pw.SizedBox(height: 20),

          // Informations générales
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du contrôle', DateFormat('dd/MM/yyyy HH:mm').format(dateControle)],
          ]),

          pw.SizedBox(height: 20),

          // Contrôles de sécurité
          _buildSectionTitle('Contrôles de Sécurité'),
          _buildControleTable([
            ['Réglette VASO', controles['vasoPresent'] && controles['vasoConforme'], controles['vasoObservation']],
            ['Robinet ROAI', controles['roaiPresent'] && controles['roaiConforme'], controles['roaiObservation']],
          ]),

          pw.SizedBox(height: 20),

          // Distances réglementaires
          _buildSectionTitle('Distances Réglementaires (GRDF)'),
          _buildDistanceTable(controles),

          pw.SizedBox(height: 20),

          // Ventilation
          _buildSectionTitle('Ventilation & Hotte'),
          _buildControleTable([
            ['Type de hotte', controles['typeHotte'] != 'Non', controles['ventilationObservation']],
            ['VMC Gaz', !controles['vmcPresent'] || controles['vmcConforme'], controles['vmcObservation']],
          ]),

          pw.SizedBox(height: 20),

          // Détecteurs
          _buildSectionTitle('Détecteurs de Sécurité'),
          _buildControleTable([
            ['Détecteur CO', controles['detecteurCO'], ''],
            ['Détecteur Gaz', controles['detecteurGaz'], ''],
            ['Détecteurs conformes', controles['detecteursConformes'], ''],
          ]),

          // Observations
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations Générales'),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGray,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                observations,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Pied de page
          _buildFooter(),
        ],
      ),
    );

    return await _saveAndSharePdf(pdf, 'rapport_reglementation_gaz_${DateFormat('yyyyMMdd_HHmm').format(dateControle)}.pdf');
  }

  /// Génère un PDF pour le module Puissance Chauffage
  static Future<File> generatePuissanceChauffagePdf({
    required String technicien,
    required String entreprise,
    required DateTime dateCalcul,
    required double surface,
    required double hauteur,
    required int nbOccupants,
    required double tempExterieure,
    required double tempInterieure,
    required Map<String, double> deperditions,
    required double puissanceChauffage,
    required double puissanceAvecSecurite,
    required String typeAppareilRecommande,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // En-tête
          _buildHeader('Rapport de Dimensionnement Thermique'),

          pw.SizedBox(height: 20),

          // Informations générales
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du calcul', DateFormat('dd/MM/yyyy HH:mm').format(dateCalcul)],
            ['Surface habitable', '${surface.toStringAsFixed(1)} m²'],
            ['Hauteur sous plafond', '${hauteur.toStringAsFixed(1)} m'],
            ['Nombre d\'occupants', nbOccupants.toString()],
          ]),

          pw.SizedBox(height: 20),

          // Conditions de calcul
          _buildSectionTitle('Conditions de Calcul'),
          _buildInfoTable([
            ['Température extérieure', '${tempExterieure.toStringAsFixed(1)} °C'],
            ['Température intérieure', '${tempInterieure.toStringAsFixed(1)} °C'],
            ['Différence de température', '${(tempInterieure - tempExterieure).toStringAsFixed(1)} °C'],
          ]),

          pw.SizedBox(height: 20),

          // Déperditions thermiques
          _buildSectionTitle('Déperditions Thermiques (W)'),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: deperditions.entries.map((entry) => pw.TableRow(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    entry.key,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '${entry.value.toStringAsFixed(1)} W',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            )).toList(),
          ),

          pw.SizedBox(height: 20),

          // Résultats
          _buildSectionTitle('Résultats du Dimensionnement'),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Déperditions totales: ${deperditions.values.reduce((a, b) => a + b).toStringAsFixed(1)} W',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Puissance chauffage nécessaire: ${puissanceChauffage.toStringAsFixed(1)} W (${(puissanceChauffage/1000).toStringAsFixed(2)} kW)',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Puissance avec sécurité (+15%): ${puissanceAvecSecurite.toStringAsFixed(1)} W (${(puissanceAvecSecurite/1000).toStringAsFixed(2)} kW)',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Type d\'appareil recommandé:',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  typeAppareilRecommande,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green800,
                  ),
                ),
              ],
            ),
          ),

          // Observations
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations'),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: _lightGray,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                observations,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],

          pw.SizedBox(height: 30),

          // Pied de page
          _buildFooter(),
        ],
      ),
    );

    return await _saveAndSharePdf(pdf, 'rapport_dimensionnement_thermique_${DateFormat('yyyyMMdd_HHmm').format(dateCalcul)}.pdf');
  }

  static Future<File> generateVmcPdf({
    required String technicien,
    required String entreprise,
    required DateTime dateCalcul,
    required List<Map<String, dynamic>> pieces,
    required double debitTotal,
    required String typeVmc,
    String? observations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          _buildHeader('Rapport de Calcul VMC'),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Informations Générales'),
          _buildInfoTable([
            ['Technicien', technicien],
            ['Entreprise', entreprise],
            ['Date du calcul', DateFormat('dd/MM/yyyy HH:mm').format(dateCalcul)],
            ['Type de VMC', typeVmc],
          ]),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Débits par Pièce'),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  _buildTableHeader('Pièce'),
                  _buildTableHeader('Surface (m²)'),
                  _buildTableHeader('Débit (m³/h)'),
                ],
              ),
              ...pieces.map((piece) => pw.TableRow(
                children: [
                  _buildTableCell(piece['nom'] ?? ''),
                  _buildTableCell(piece['surface']?.toStringAsFixed(1) ?? ''),
                  _buildTableCell(piece['debit']?.toStringAsFixed(0) ?? ''),
                ],
              )),
            ],
          ),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Résultats'),
          _buildInfoTable([
            ['Débit total calculé', '${debitTotal.toStringAsFixed(0)} m³/h'],
            ['Recommandation', typeVmc == 'simple flux' ? 'VMC simple flux' : 'VMC double flux'],
          ]),
          if (observations != null && observations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildSectionTitle('Observations'),
            pw.Text(observations),
          ],
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
    return await _saveAndSharePdf(pdf, 'rapport_vmc_${DateFormat('yyyyMMdd_HHmm').format(dateCalcul)}.pdf');
  }
}
