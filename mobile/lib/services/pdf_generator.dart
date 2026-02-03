import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:chauffageexpert/services/json_exporter.dart';
import 'package:chauffageexpert/utils/app_utils.dart';

class PDFGeneratorService with PDFGeneratorMixin, SharedPreferencesMixin {
  // Singleton pattern
  PDFGeneratorService._();
  static final PDFGeneratorService instance = PDFGeneratorService._();
  
  static const String _version = '1.0.0';
  
  // Génération PDF pour relevé technique
  Future<File> genererReleveTechnique({
    required Map<String, Map<String, String>> donnees,
    required String typeReleve,
  }) async {
    final pdf = pw.Document();
    
    // Informations entreprise
    final entrepriseNom = await loadString('entrepriseNom', defaultValue: 'Entreprise');
    final entrepriseAdresse = await loadString('entrepriseAdresse', defaultValue: '');
    final entrepriseVille = await loadString('entrepriseVille', defaultValue: '');
    final entrepriseCodePostal = await loadString('entrepriseCodePostal', defaultValue: '');
    final entrepriseTelephone = await loadString('entrepriseTelephone', defaultValue: '');
    final entrepriseEmail = await loadString('entrepriseEmail', defaultValue: '');
    final entrepriseSiret = await loadString('entrepriseSiret', defaultValue: '');
    
    // Informations technicien
    final technicienNom = await loadString('technicienNom', defaultValue: 'Technicien');
    final technicienQualification = await loadString('technicienQualification', defaultValue: '');
    
    // Construire une section "Réglementation Gaz" depuis SharedPreferences
    final Map<String, String> reglementationSection = {
      'Vase d\'expansion présent': await loadString('vasoPresent', defaultValue: 'NC'),
      'Vase d\'expansion conforme': await loadString('vasoConforme', defaultValue: 'NC'),
      'Observation vase': await loadString('vasoObservation', defaultValue: ''),
      'ROAI présent': await loadString('roaiPresent', defaultValue: 'NC'),
      'ROAI conforme': await loadString('roaiConforme', defaultValue: 'NC'),
      'Observation ROAI': await loadString('roaiObservation', defaultValue: ''),
      'Type hotte': await loadString('typeHotte', defaultValue: ''),
      'Ventilation conforme': await loadString('ventilationConforme', defaultValue: 'NC'),
      'Observation ventilation': await loadString('ventilationObservation', defaultValue: ''),
      'VMC présent': await loadString('vmcPresent', defaultValue: 'NC'),
      'VMC conforme': await loadString('vmcConforme', defaultValue: 'NC'),
      'Observation VMC': await loadString('vmcObservation', defaultValue: ''),
      'Détecteur CO': await loadString('detecteurCO', defaultValue: 'NC'),
      'Détecteur Gaz': await loadString('detecteurGaz', defaultValue: 'NC'),
      'Détecteurs conformes': await loadString('detecteursConformes', defaultValue: 'NC'),
      'Distance fenêtre (m)': await loadString('distanceFenetre', defaultValue: ''),
      'Distance porte (m)': await loadString('distancePorte', defaultValue: ''),
      'Distance évacuation (m)': await loadString('distanceEvacuation', defaultValue: ''),
      'Distance aspiration (m)': await loadString('distanceAspiration', defaultValue: ''),
    };

    // Fusionner la section réglementation au jeu de sections fourni (si non vide)
    final sections = <String, Map<String, String>>{};
    sections.addAll(donnees);
    // Ajouter la section seulement si une valeur est présente (ou pour la visibilité)
    sections['Réglementation Gaz'] = reglementationSection;

    // Récupérer le diagnostic complet pour résumé et anomalies
    final diagnosticGaz = await JSONExporter.collectDiagnosticGaz();
    final Map<String, int> severityCounts = {};
    final List<Map<String, dynamic>> anomalies = [];
    try {
      diagnosticGaz.forEach((sectionId, sec) {
        final qs = (sec['questions'] as List<dynamic>?) ?? [];
        for (final q in qs) {
          final value = (q['value'] ?? '').toString();
          final severity = (q['severity'] ?? 'low').toString();
          if (value.toLowerCase() == 'non') {
            anomalies.add({
              'section': sec['titre'] ?? sectionId,
              'id': q['id'],
              'text': q['text'],
              'value': value,
              'observation': q['observation'] ?? '',
              'severity': severity,
            });
            severityCounts[severity] = (severityCounts[severity] ?? 0) + 1;
          }
        }
      });
    } catch (e) {
      // ignore
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => buildPDFHeader(
          title: typeReleve,
          entreprise: entrepriseNom,
        ),
        footer: (context) => buildPDFFooter(context, version: _version),
        build: (context) => [
          // En-tête du relevé - Informations entreprise et client
          buildEntrepriseInfo(
            nom: entrepriseNom,
            adresse: entrepriseAdresse,
            ville: entrepriseVille,
            codePostal: entrepriseCodePostal,
            telephone: entrepriseTelephone,
            email: entrepriseEmail,
            siret: entrepriseSiret,
          ),
          
          buildSection(
            title: 'Informations Technicien',
            children: [
              buildInfoRow('Nom', technicienNom),
              buildInfoRow('Qualification', technicienQualification),
            ],
          ),
          
          pw.SizedBox(height: 20),
          
          // Contenu du relevé par sections
          ...sections.entries.map((section) => 
            buildSection(
              title: section.key,
              children: section.value.entries.map((entry) =>
                buildInfoRow(entry.key, entry.value)
              ).toList(),
            )
          ),
          
          pw.SizedBox(height: 30),
          // Diagnostic résumé et anomalies
          if (diagnosticGaz.isNotEmpty) ...[
            _buildDiagnosticSummary(severityCounts),
            pw.SizedBox(height: 12),
            _buildAnomaliesList(anomalies),
            pw.SizedBox(height: 20),
          ],
          
          // Signature
          _buildSignatureSection(),
        ],
      ),
    );

    return _saveAndReturnFile(pdf, 'releve_${typeReleve}_${DateTime.now().millisecondsSinceEpoch}');
  }

  // Génération PDF pour calcul de puissance
  Future<File> genererCalculPuissance({
    required Map<String, dynamic> donnees,
    required double puissanceCalculee,
    required String methode,
  }) async {
    final pdf = pw.Document();
    
    final entrepriseNom = await loadString('entrepriseNom', defaultValue: 'Entreprise');
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => buildPDFHeader(
          title: 'Calcul de Puissance',
          entreprise: entrepriseNom,
        ),
        footer: (context) => buildPDFFooter(context, version: _version),
        build: (context) => [
          _buildCalculHeader(),
          
          pw.SizedBox(height: 20),
          
          // Méthode utilisée
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Text(
              'Méthode: $methode',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          
          pw.SizedBox(height: 15),
          
          // Données d'entrée
          _buildDonneesEntree(donnees),
          
          pw.SizedBox(height: 20),
          
          // Résultat
          _buildResultatPuissance(puissanceCalculee),
          
          pw.SizedBox(height: 20),
          
          // Notes techniques
          _buildNotesTechniques(),
        ],
      ),
    );

    return _saveAndReturnFile(pdf, 'calcul_puissance_${DateTime.now().millisecondsSinceEpoch}');
  }

  // Génération PDF pour test VMC
  Future<File> genererTestVMC({
    required Map<String, dynamic> donnees,
    required bool conforme,
  }) async {
    final pdf = pw.Document();
    
    final entrepriseNom = await loadString('entrepriseNom', defaultValue: 'Entreprise');
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => buildPDFHeader(
          title: 'Test VMC',
          entreprise: entrepriseNom,
        ),
        footer: (context) => buildPDFFooter(context, version: _version),
        build: (context) => [
          _buildVMCHeader(),
          
          pw.SizedBox(height: 20),
          
          // Statut de conformité
          buildStatusCard(
            title: conforme ? 'CONFORME' : 'NON CONFORME',
            message: conforme 
              ? 'L\'installation VMC est conforme aux normes'
              : 'L\'installation VMC nécessite des corrections',
            status: conforme ? 'success' : 'error',
          ),
          
          pw.SizedBox(height: 20),
          
          // Détails des mesures
          _buildMesuresVMC(donnees),
          
          pw.SizedBox(height: 20),
          
          // Recommandations
          _buildRecommandationsVMC(conforme),
        ],
      ),
    );

    return _saveAndReturnFile(pdf, 'test_vmc_${DateTime.now().millisecondsSinceEpoch}');
  }

  // Section signature
  static pw.Widget _buildSignatureSection() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text('Signature du technicien:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
              pw.Container(height: 1, color: PdfColors.black),
            ],
          ),
        ),
        pw.SizedBox(width: 40),
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text('Signature du client:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
              pw.Container(height: 1, color: PdfColors.black),
            ],
          ),
        ),
      ],
    );
  }

  // En-tête pour calcul
  static pw.Widget _buildCalculHeader() {
    return pw.Text(
      'CALCUL DE PUISSANCE DE CHAUFFAGE',
      style: pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue800,
      ),
    );
  }

  // Données d'entrée pour calcul
  static pw.Widget _buildDonneesEntree(Map<String, dynamic> donnees) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Données d\'entrée:',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: donnees.entries.map((entry) =>
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(entry.key),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(entry.value.toString()),
                ),
              ],
            ),
          ).toList(),
        ),
      ],
    );
  }

  // Résultat puissance
  static pw.Widget _buildResultatPuissance(double puissance) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Text(
        'PUISSANCE RECOMMANDÉE: ${puissance.toStringAsFixed(2)} kW',
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.green800,
        ),
      ),
    );
  }

  // Notes techniques
  static pw.Widget _buildNotesTechniques() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes techniques:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            '• Ce calcul est indicatif et doit être validé par un professionnel\n'
            '• Les conditions réelles peuvent différer des hypothèses de calcul\n'
            '• Respecter les normes et réglementations en vigueur',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  // Résumé diagnostic: compte par sévérité
  static pw.Widget _buildDiagnosticSummary(Map<String, int> severityCounts) {
    if (severityCounts.isEmpty) {
      return pw.Container();
    }
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Résumé Diagnostic Gaz', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ...severityCounts.entries.map((e) => pw.Text('- ${e.key.toUpperCase()}: ${e.value} anomalies')),
        ],
      ),
    );
  }

  // Liste des anomalies détectées
  static pw.Widget _buildAnomaliesList(List<Map<String, dynamic>> anomalies) {
    if (anomalies.isEmpty) return pw.Container();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Anomalies détectées', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.ListView.builder(
          itemCount: anomalies.length,
          itemBuilder: (context, idx) {
            final a = anomalies[idx];
            return pw.Container(
              padding: const pw.EdgeInsets.all(8),
              margin: const pw.EdgeInsets.only(bottom: 6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('${a['section']} — ${a['text']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('Sévérité: ${a['severity']} | Valeur: ${a['value']}'),
                  if ((a['observation'] ?? '').toString().isNotEmpty) pw.Text('Observation: ${a['observation']}'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // En-tête VMC
  static pw.Widget _buildVMCHeader() {
    return pw.Text(
      'TEST DE CONFORMITÉ VMC',
      style: pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue800,
      ),
    );
  }

  // Mesures VMC
  static pw.Widget _buildMesuresVMC(Map<String, dynamic> donnees) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Mesures effectuées:',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: donnees.entries.map((entry) =>
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(entry.key),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(entry.value.toString()),
                ),
              ],
            ),
          ).toList(),
        ),
      ],
    );
  }

  // Recommandations VMC
  static pw.Widget _buildRecommandationsVMC(bool conforme) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: conforme ? PdfColors.green50 : PdfColors.orange50,
        border: pw.Border.all(color: conforme ? PdfColors.green : PdfColors.orange),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Recommandations:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            conforme
                ? '• L\'installation VMC est conforme aux normes\n'
                  '• Maintenir un entretien régulier\n'
                  '• Vérifier périodiquement les débits'
                : '• Correction nécessaire pour mise en conformité\n'
                  '• Contacter un professionnel qualifié\n'
                  '• Effectuer un nouveau contrôle après intervention',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  // Sauvegarde du fichier
  static Future<File> _saveAndReturnFile(pw.Document pdf, String filename) async {
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/$filename.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
