import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

/// Mixin pour la génération de PDF avec éléments communs
/// 
/// Fournit des méthodes réutilisables pour créer des PDF
/// avec un style cohérent dans toute l'application
mixin PDFGeneratorMixin {
  /// Format de date standard pour les PDF
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  
  /// Constantes de style
  static const double headerFontSize = 24.0;
  static const double titleFontSize = 18.0;
  static const double subtitleFontSize = 14.0;
  static const double bodyFontSize = 11.0;
  static const double smallFontSize = 9.0;
  
  static const double defaultPadding = 10.0;
  static const double largePadding = 20.0;
  static const double smallPadding = 5.0;
  
  /// Construit l'en-tête du PDF
  pw.Widget buildPDFHeader({
    required String title,
    String? entreprise,
    String? subtitle,
  }) {
    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: headerFontSize,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              if (entreprise != null)
                pw.Text(
                  entreprise,
                  style: pw.TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            pw.SizedBox(height: smallPadding),
            pw.Text(
              subtitle,
              style: pw.TextStyle(
                fontSize: subtitleFontSize,
                color: PdfColors.grey700,
              ),
            ),
          ],
          pw.SizedBox(height: smallPadding),
          pw.Divider(thickness: 2, color: PdfColors.blue900),
        ],
      ),
    );
  }
  
  /// Construit le pied de page du PDF
  pw.Widget buildPDFFooter(pw.Context context, {String? version}) {
    return pw.Footer(
      margin: const pw.EdgeInsets.only(top: defaultPadding),
      child: pw.Column(
        children: [
          pw.Divider(thickness: 1),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Page ${context.pageNumber}/${context.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: smallFontSize,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                'Généré le ${_dateTimeFormat.format(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: smallFontSize,
                  color: PdfColors.grey600,
                ),
              ),
              if (version != null)
                pw.Text(
                  'v$version',
                  style: const pw.TextStyle(
                    fontSize: smallFontSize,
                    color: PdfColors.grey600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Construit une section avec titre
  pw.Widget buildSection({
    required String title,
    required List<pw.Widget> children,
    PdfColor? backgroundColor,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: defaultPadding),
      padding: const pw.EdgeInsets.all(defaultPadding),
      decoration: pw.BoxDecoration(
        color: backgroundColor ?? PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: titleFontSize,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: defaultPadding),
          ...children,
        ],
      ),
    );
  }
  
  /// Construit une ligne d'information clé-valeur
  pw.Widget buildInfoRow(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: smallPadding),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: bodyFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: bodyFontSize,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construit un tableau simple
  pw.Widget buildTable({
    required List<String> headers,
    required List<List<String>> rows,
    List<double>? columnWidths,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: columnWidths != null
          ? Map.fromIterables(
              List.generate(columnWidths.length, (i) => i),
              columnWidths.map((w) => pw.FixedColumnWidth(w)),
            )
          : null,
      children: [
        // En-tête
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: headers.map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              h,
              style: pw.TextStyle(
                fontSize: bodyFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          )).toList(),
        ),
        // Lignes
        ...rows.map((row) => pw.TableRow(
          children: row.map((cell) => pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              cell,
              style: const pw.TextStyle(fontSize: bodyFontSize),
            ),
          )).toList(),
        )),
      ],
    );
  }
  
  /// Construit une carte de statut (succès/avertissement/erreur)
  pw.Widget buildStatusCard({
    required String title,
    required String message,
    required String status, // 'success', 'warning', 'error', 'info'
    String? percentage,
  }) {
    PdfColor backgroundColor;
    PdfColor textColor = PdfColors.white;
    
    switch (status) {
      case 'success':
        backgroundColor = PdfColors.green500;
        break;
      case 'warning':
        backgroundColor = PdfColors.orange500;
        break;
      case 'error':
        backgroundColor = PdfColors.red500;
        break;
      case 'info':
      default:
        backgroundColor = PdfColors.blue500;
    }
    
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: defaultPadding),
      padding: const pw.EdgeInsets.all(defaultPadding),
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: titleFontSize,
              fontWeight: pw.FontWeight.bold,
              color: textColor,
            ),
          ),
          pw.SizedBox(height: smallPadding),
          if (percentage != null)
            pw.Text(
              percentage,
              style: pw.TextStyle(
                fontSize: headerFontSize,
                fontWeight: pw.FontWeight.bold,
                color: textColor,
              ),
            ),
          pw.SizedBox(height: smallPadding),
          pw.Text(
            message,
            style: pw.TextStyle(
              fontSize: bodyFontSize,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Construit un bloc d'informations entreprise
  pw.Widget buildEntrepriseInfo({
    required String nom,
    String? adresse,
    String? ville,
    String? codePostal,
    String? telephone,
    String? email,
    String? siret,
  }) {
    return buildSection(
      title: 'Informations Entreprise',
      children: [
        buildInfoRow('Nom', nom),
        if (adresse != null && adresse.isNotEmpty)
          buildInfoRow('Adresse', adresse),
        if (ville != null && codePostal != null)
          buildInfoRow('Ville', '$codePostal $ville'),
        if (telephone != null && telephone.isNotEmpty)
          buildInfoRow('Téléphone', telephone),
        if (email != null && email.isNotEmpty)
          buildInfoRow('Email', email),
        if (siret != null && siret.isNotEmpty)
          buildInfoRow('SIRET', siret),
      ],
    );
  }
  
  /// Construit un bloc d'informations client
  pw.Widget buildClientInfo({
    required String nom,
    String? adresse,
    String? telephone,
    String? email,
  }) {
    return buildSection(
      title: 'Informations Client',
      children: [
        buildInfoRow('Nom', nom),
        if (adresse != null && adresse.isNotEmpty)
          buildInfoRow('Adresse', adresse),
        if (telephone != null && telephone.isNotEmpty)
          buildInfoRow('Téléphone', telephone),
        if (email != null && email.isNotEmpty)
          buildInfoRow('Email', email),
      ],
    );
  }
  
  /// Construit une liste à puces
  pw.Widget buildBulletList(List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.map((item) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: smallPadding),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('• ', style: const pw.TextStyle(fontSize: bodyFontSize)),
            pw.Expanded(
              child: pw.Text(item, style: const pw.TextStyle(fontSize: bodyFontSize)),
            ),
          ],
        ),
      )).toList(),
    );
  }
  
  /// Formate une date
  String formatDate(DateTime date) => _dateFormat.format(date);
  
  /// Formate une date et heure
  String formatDateTime(DateTime date) => _dateTimeFormat.format(date);
  
  /// Construit un badge de conformité
  pw.Widget buildConformityBadge(String value) {
    PdfColor color;
    switch (value.toUpperCase()) {
      case 'OUI':
      case 'CONFORME':
        color = PdfColors.green;
        break;
      case 'NON':
      case 'NON CONFORME':
        color = PdfColors.red;
        break;
      case 'NC':
      case 'N/A':
      default:
        color = PdfColors.grey;
    }
    
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
      ),
      child: pw.Text(
        value,
        style: const pw.TextStyle(
          fontSize: smallFontSize,
          color: PdfColors.white,
        ),
      ),
    );
  }
}
