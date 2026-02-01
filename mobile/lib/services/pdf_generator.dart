import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:chauffage_expert/services/json_exporter.dart';

class PDFGeneratorService {
  static const String _version = '1.0.0';
  
  // Génération PDF pour relevé technique
  static Future<File> genererReleveTechnique({
    required Map<String, Map<String, String>> donnees,
    required String typeReleve,
  }) async {
    final pdf = pw.Document();
    final prefs = await SharedPreferences.getInstance();
    
    // Informations entreprise
    final entrepriseNom = prefs.getString('entrepriseNom') ?? 'Entreprise';
    final entrepriseAdresse = prefs.getString('entrepriseAdresse') ?? '';
    final entrepriseVille = prefs.getString('entrepriseVille') ?? '';
    final entrepriseCodePostal = prefs.getString('entrepriseCodePostal') ?? '';
    final entrepriseTelephone = prefs.getString('entrepriseTelephone') ?? '';
    final entrepriseEmail = prefs.getString('entrepriseEmail') ?? '';
    final entrepriseSiret = prefs.getString('entrepriseSiret') ?? '';
    
    // Informations technicien
    final technicienNom = prefs.getString('technicienNom') ?? 'Technicien';
    final technicienQualification = prefs.getString('technicienQualification') ?? '';
    
    // Construire une section "Réglementation Gaz" depuis SharedPreferences
    final Map<String, String> reglementationSection = {
      'Vase d\'expansion présent': prefs.getString('vasoPresent') ?? 'NC',
      'Vase d\'expansion conforme': prefs.getString('vasoConforme') ?? 'NC',
      'Observation vase': prefs.getString('vasoObservation') ?? '',
      'ROAI présent': prefs.getString('roaiPresent') ?? 'NC',
      'ROAI conforme': prefs.getString('roaiConforme') ?? 'NC',
      'Observation ROAI': prefs.getString('roaiObservation') ?? '',
      'Type hotte': prefs.getString('typeHotte') ?? '',
      'Ventilation conforme': prefs.getString('ventilationConforme') ?? 'NC',
      'Observation ventilation': prefs.getString('ventilationObservation') ?? '',
      'VMC présent': prefs.getString('vmcPresent') ?? 'NC',
      'VMC conforme': prefs.getString('vmcConforme') ?? 'NC',
      'Observation VMC': prefs.getString('vmcObservation') ?? '',
      'Détecteur CO': prefs.getString('detecteurCO') ?? 'NC',
      'Détecteur Gaz': prefs.getString('detecteurGaz') ?? 'NC',
      'Détecteurs conformes': prefs.getString('detecteursConformes') ?? 'NC',
      'Distance fenêtre (m)': prefs.getString('distanceFenetre') ?? '',
      'Distance porte (m)': prefs.getString('distancePorte') ?? '',
      'Distance évacuation (m)': prefs.getString('distanceEvacuation') ?? '',
      'Distance aspiration (m)': prefs.getString('distanceAspiration') ?? '',
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
        header: (context) => _buildHeader(
          entrepriseNom,
          typeReleve,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          // En-tête du relevé
          _buildReleveHeader(
            entrepriseNom,
            entrepriseAdresse,
            entrepriseVille,
            entrepriseCodePostal,
            entrepriseTelephone,
            entrepriseEmail,
            entrepriseSiret,
            technicienNom,
            technicienQualification,
            typeReleve,
          ),
          
          pw.SizedBox(height: 20),
          
          // Contenu du relevé par sections
          ...sections.entries.map((section) => 
            _buildSection(section.key, section.value)
          ),
          
          pw.SizedBox(height: 30),
          
          // Signature
          _buildSignatureSection(),
        ],
      ),
    );

    return _saveAndReturnFile(pdf, 'releve_${typeReleve}_${DateTime.now().millisecondsSinceEpoch}');
  }

  // Génération PDF pour calcul de puissance
  static Future<File> genererCalculPuissance({
    required Map<String, dynamic> donnees,
    required double puissanceCalculee,
    required String methode,
  }) async {
    final pdf = pw.Document();
    final prefs = await SharedPreferences.getInstance();
    
    final entrepriseNom = prefs.getString('entrepriseNom') ?? 'Entreprise';
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(entrepriseNom, 'Calcul de Puissance'),
        footer: (context) => _buildFooter(context),
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
          // Diagnostic résumé et anomalies
          if (diagnosticGaz.isNotEmpty) ...[
            _buildDiagnosticSummary(severityCounts),
            pw.SizedBox(height: 12),
            _buildAnomaliesList(anomalies),
            pw.SizedBox(height: 20),
          ],
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
  static Future<File> genererTestVMC({
    required Map<String, dynamic> donnees,
    required bool conforme,
  }) async {
    final pdf = pw.Document();
    final prefs = await SharedPreferences.getInstance();
    
    final entrepriseNom = prefs.getString('entrepriseNom') ?? 'Entreprise';
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(entrepriseNom, 'Test VMC'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildVMCHeader(),
          
          pw.SizedBox(height: 20),
          
          // Statut de conformité
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              color: conforme ? PdfColors.green100 : PdfColors.red100,
              border: pw.Border.all(
                color: conforme ? PdfColors.green : PdfColors.red,
                width: 2,
              ),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Row(
              children: [
                pw.Icon(
                  conforme ? const pw.IconData(0xe876) : const pw.IconData(0xe000),
                  color: conforme ? PdfColors.green : PdfColors.red,
                  size: 24,
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  conforme ? 'INSTALLATION CONFORME' : 'INSTALLATION NON CONFORME',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: conforme ? PdfColors.green800 : PdfColors.red800,
                  ),
                ),
              ],
            ),
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

  // Construction de l'en-tête
  static pw.Widget _buildHeader(String entrepriseNom, String typeDocument) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entrepriseNom,
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                typeDocument,
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.Text(
            DateFormat('dd/MM/yyyy').format(DateTime.now()),
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Construction du pied de page
  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey, width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Généré par Chauffage Expert v$_version',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  // Construction d'une section de relevé
  static pw.Widget _buildSection(String titre, Map<String, String> donnees) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          titre,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: donnees.entries.map((entry) =>
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    entry.key,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(entry.value),
                ),
              ],
            ),
          ).toList(),
        ),
        pw.SizedBox(height: 15),
      ],
    );
  }

  // En-tête pour relevé technique
  static pw.Widget _buildReleveHeader(
    String entrepriseNom,
    String entrepriseAdresse,
    String entrepriseVille,
    String entrepriseCodePostal,
    String entrepriseTelephone,
    String entrepriseEmail,
    String entrepriseSiret,
    String technicienNom,
    String technicienQualification,
    String typeReleve,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RELEVÉ TECHNIQUE - ${typeReleve.toUpperCase()}',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('ENTREPRISE:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(entrepriseNom),
                    if (entrepriseAdresse.isNotEmpty) pw.Text(entrepriseAdresse),
                    if (entrepriseCodePostal.isNotEmpty || entrepriseVille.isNotEmpty)
                      pw.Text('$entrepriseCodePostal $entrepriseVille'),
                    if (entrepriseTelephone.isNotEmpty) pw.Text('Tél: $entrepriseTelephone'),
                    if (entrepriseEmail.isNotEmpty) pw.Text('Email: $entrepriseEmail'),
                    if (entrepriseSiret.isNotEmpty) pw.Text('SIRET: $entrepriseSiret'),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TECHNICIEN:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(technicienNom),
                    if (technicienQualification.isNotEmpty)
                      pw.Text('Qualification: $technicienQualification'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      decoration: pw.BoxDecoration(
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
