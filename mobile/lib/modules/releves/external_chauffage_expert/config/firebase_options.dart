// config/firebase_options.dart
// Configuration Firebase temporairement désactivée
/*
// config/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'firebase_secrets.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions ne sont pas configurés pour ${defaultTargetPlatform.name}',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: FirebaseSecrets.webApiKey,
        appId: FirebaseSecrets.webAppId,
        messagingSenderId: FirebaseSecrets.webMessagingSenderId,
        projectId: FirebaseSecrets.webProjectId,
        authDomain: FirebaseSecrets.webAuthDomain,
        storageBucket: FirebaseSecrets.webStorageBucket,
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: FirebaseSecrets.androidApiKey,
        appId: FirebaseSecrets.androidAppId,
        messagingSenderId: FirebaseSecrets.androidMessagingSenderId,
        projectId: FirebaseSecrets.androidProjectId,
        storageBucket: FirebaseSecrets.androidStorageBucket,
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: FirebaseSecrets.iosApiKey,
        appId: FirebaseSecrets.iosAppId,
        messagingSenderId: FirebaseSecrets.iosMessagingSenderId,
        projectId: FirebaseSecrets.iosProjectId,
        storageBucket: FirebaseSecrets.iosStorageBucket,
        iosClientId: FirebaseSecrets.iosClientId,
        iosBundleId: FirebaseSecrets.iosBundleId,
      );
}
*/

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions n\'a pas été configuré pour Windows - '
          'vous pouvez le reconfigurer via l\'interface Firebase CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions n\'a pas été configuré pour Linux - '
          'vous pouvez le reconfigurer via l\'interface Firebase CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions n\'est pas supporté pour cette plateforme.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY',
    appId: 'VOTRE_APP_ID',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    projectId: 'VOTRE_PROJECT_ID',
    authDomain: 'VOTRE_AUTH_DOMAIN',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
    measurementId: 'VOTRE_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY',
    appId: 'VOTRE_APP_ID',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    projectId: 'VOTRE_PROJECT_ID',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY',
    appId: 'VOTRE_APP_ID',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    projectId: 'VOTRE_PROJECT_ID',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
    iosClientId: 'VOTRE_IOS_CLIENT_ID',
    iosBundleId: 'VOTRE_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY',
    appId: 'VOTRE_APP_ID',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    projectId: 'VOTRE_PROJECT_ID',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
    iosClientId: 'VOTRE_IOS_CLIENT_ID',
    iosBundleId: 'VOTRE_IOS_BUNDLE_ID',
  );
}
