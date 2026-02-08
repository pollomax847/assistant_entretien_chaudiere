// new_project/lib/services/_p_d_f_service.dart (externe)
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/releve_vqs.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_storage_service.dart';
import 'firebase_auth_service.dart';

class PDFService {
  static final FirebaseStorageService _storageService =
      FirebaseStorageService();
  static final FirebaseAuthService _authService = FirebaseAuthService();

  static String _genererNomFichier(ReleveVQS releve) {
    final date = DateFormat('dd_MM_yyyy').format(releve.dateCreation);
    final nom = releve.nomPersonneControlee
            ?.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_') ??
        'anonyme';
    final type = releve.typeIntervention?.toLowerCase() ?? 'standard';
    return 'rapport_${nom}_${type}_$date.pdf';
  }

  static Future<File> genererPDFVQS(ReleveVQS releve) async {
    final pdf = pw.Document();

    // Création du PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(),
          _buildTitle(releve),
          ...releve.sections.entries
              .map((section) => _buildSection(section.key, section.value))
              .toList(),
          if (releve.photos.isNotEmpty) _buildPhotos(releve),
          _buildSignatures(releve),
        ],
      ),
    );

    // Sauvegarde du fichier avec le nouveau nom
    final output = await getTemporaryDirectory();
    final fileName = _genererNomFichier(releve);
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    // Si l'utilisateur est connecté, sauvegarder dans Firebase
    if (_authService.isSignedIn) {
      try {
        final downloadUrl = await _storageService.uploadReport(file, 'vqs');
        print('Rapport sauvegardé dans Firebase: $downloadUrl');
      } catch (e) {
        print('Erreur lors de la sauvegarde dans Firebase: $e');
      }
    }

    return file;
  }

  static pw.Widget _buildHeader() {
    return pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Évaluation de la sécurité et de la qualité\ndes interventions techniques',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            DateFormat('dd/MM/yyyy').format(DateTime.now()),
            style: const pw.TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitle(ReleveVQS releve) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      margin: const pw.EdgeInsets.only(bottom: 20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Rapport N° ${releve.id}',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
              'Date de création: ${DateFormat('dd/MM/yyyy HH:mm').format(releve.dateCreation)}'),
          if (releve.dateModification != null)
            pw.Text(
                'Dernière modification: ${DateFormat('dd/MM/yyyy HH:mm').format(releve.dateModification!)}'),
        ],
      ),
    );
  }

  static pw.Widget _buildSection(String title, List<String> values) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          ...values.map((value) => pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: pw.Text(value),
              )),
        ],
      ),
    );
  }

  static pw.Widget _buildPhotos(ReleveVQS releve) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Photos',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Wrap(
            spacing: 10,
            runSpacing: 10,
            children: releve.photos
                .map(
                  (photo) => pw.Container(
                    width: 150,
                    height: 150,
                    child: pw.Image(
                      pw.MemoryImage(photo.readAsBytesSync()),
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatures(ReleveVQS releve) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          if (releve.signatureControleur != null)
            pw.Column(
              children: [
                pw.Text('Signature du contrôleur'),
                pw.SizedBox(height: 5),
                pw.Container(
                  width: 200,
                  height: 100,
                  child: pw.Image(
                    pw.MemoryImage(releve.signatureControleur!),
                  ),
                ),
              ],
            ),
          if (releve.signatureControle != null)
            pw.Column(
              children: [
                pw.Text('Signature de la personne contrôlée'),
                pw.SizedBox(height: 5),
                pw.Container(
                  width: 200,
                  height: 100,
                  child: pw.Image(
                    pw.MemoryImage(releve.signatureControle!),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static Future<void> partagerPDF(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text:
          'Évaluation de la sécurité et de la qualité des interventions techniques',
    );
  }

  static Future<void> envoyerParEmail(File file, String destinataire) async {
    if (_authService.isSignedIn) {
      try {
        // Sauvegarder dans Firebase et obtenir l'URL de téléchargement
        final downloadUrl = await _storageService.uploadReport(file, 'vqs');

        // Créer un partage dans Firestore
        await _storageService.shareReport(
          file.path.split('/').last,
          destinataire,
        );

        // Envoyer l'email avec le lien de téléchargement
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: destinataire,
          query:
              'subject=Rapport d\'évaluation&body=Voici le lien pour télécharger le rapport : $downloadUrl',
        );

        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          throw 'Impossible d\'ouvrir le client mail';
        }
      } catch (e) {
        print('Erreur lors de l\'envoi par email: $e');
        // Fallback : partager directement le fichier
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'Rapport d\'évaluation',
          text: 'Veuillez trouver ci-joint le rapport d\'évaluation.',
        );
      }
    } else {
      // Si non connecté, utiliser le partage standard
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Rapport d\'évaluation',
        text: 'Veuillez trouver ci-joint le rapport d\'évaluation.',
      );
    }
  }
}
