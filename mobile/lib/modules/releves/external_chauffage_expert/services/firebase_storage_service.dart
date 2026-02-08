// services/firebase_storage_service.dart (externe)
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_auth_service.dart';

class FirebaseStorageService {
  static final FirebaseStorageService _instance =
      FirebaseStorageService._internal();
  factory FirebaseStorageService() => _instance;
  FirebaseStorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Sauvegarder un rapport PDF
  Future<String> uploadReport(File file, String type) async {
    if (!_auth.isSignedIn) throw Exception('Utilisateur non connecté');

    try {
      final userId = _auth.currentUser!.uid;
      final fileName = path.basename(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath = 'reports/$userId/$type/$timestamp-$fileName';

      // Upload du fichier
      final ref = _storage.ref().child(storagePath);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Sauvegarder les métadonnées dans Firestore
      await _firestore.collection('reports').add({
        'userId': userId,
        'type': type,
        'fileName': fileName,
        'storagePath': storagePath,
        'downloadUrl': downloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'size': await file.length(),
      });

      return downloadUrl;
    } catch (e) {
      print('Erreur lors de l\'upload du rapport: $e');
      rethrow;
    }
  }

  // Récupérer les rapports d'un utilisateur
  Stream<QuerySnapshot> getUserReports(String type) {
    if (!_auth.isSignedIn) throw Exception('Utilisateur non connecté');

    return _firestore
        .collection('reports')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Supprimer un rapport
  Future<void> deleteReport(String reportId) async {
    if (!_auth.isSignedIn) throw Exception('Utilisateur non connecté');

    try {
      // Récupérer les informations du rapport
      final reportDoc =
          await _firestore.collection('reports').doc(reportId).get();

      if (!reportDoc.exists) throw Exception('Rapport non trouvé');

      final data = reportDoc.data() as Map<String, dynamic>;

      // Vérifier que l'utilisateur est propriétaire du rapport
      if (data['userId'] != _auth.currentUser!.uid) {
        throw Exception('Non autorisé à supprimer ce rapport');
      }

      // Supprimer le fichier du storage
      final ref = _storage.ref().child(data['storagePath']);
      await ref.delete();

      // Supprimer les métadonnées de Firestore
      await _firestore.collection('reports').doc(reportId).delete();
    } catch (e) {
      print('Erreur lors de la suppression du rapport: $e');
      rethrow;
    }
  }

  // Partager un rapport
  Future<void> shareReport(String reportId, String recipientEmail) async {
    if (!_auth.isSignedIn) throw Exception('Utilisateur non connecté');

    try {
      final reportDoc =
          await _firestore.collection('reports').doc(reportId).get();

      if (!reportDoc.exists) throw Exception('Rapport non trouvé');

      final data = reportDoc.data() as Map<String, dynamic>;

      // Vérifier que l'utilisateur est propriétaire du rapport
      if (data['userId'] != _auth.currentUser!.uid) {
        throw Exception('Non autorisé à partager ce rapport');
      }

      // Créer un partage dans Firestore
      await _firestore.collection('shared_reports').add({
        'reportId': reportId,
        'sharedBy': _auth.currentUser!.uid,
        'sharedWith': recipientEmail,
        'sharedAt': FieldValue.serverTimestamp(),
        'downloadUrl': data['downloadUrl'],
        'type': data['type'],
        'fileName': data['fileName'],
      });

      // TODO: Envoyer un email de notification
    } catch (e) {
      print('Erreur lors du partage du rapport: $e');
      rethrow;
    }
  }

  // Récupérer les rapports partagés avec l'utilisateur
  Stream<QuerySnapshot> getSharedReports() {
    if (!_auth.isSignedIn) throw Exception('Utilisateur non connecté');

    return _firestore
        .collection('shared_reports')
        .where('sharedWith', isEqualTo: _auth.currentUser!.email)
        .orderBy('sharedAt', descending: true)
        .snapshots();
  }

  // Générer une URL de téléchargement temporaire
  Future<String> getTemporaryDownloadUrl(String storagePath) async {
    if (!_auth.isSignedIn) throw Exception('Utilisateur non connecté');

    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Erreur lors de la génération de l\'URL: $e');
      rethrow;
    }
  }
}
