import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.get('FIREBASE_WEB_API_KEY', fallback: ''),
        appId: dotenv.get('FIREBASE_WEB_APP_ID', fallback: ''),
        messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID', fallback: ''),
        projectId: dotenv.get('FIREBASE_PROJECT_ID', fallback: ''),
        authDomain: '${dotenv.get('FIREBASE_PROJECT_ID', fallback: '')}.firebaseapp.com',
        storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET', fallback: ''),
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.get('FIREBASE_ANDROID_API_KEY', fallback: ''),
        appId: dotenv.get('FIREBASE_ANDROID_APP_ID', fallback: ''),
        messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID', fallback: ''),
        projectId: dotenv.get('FIREBASE_PROJECT_ID', fallback: ''),
        storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET', fallback: ''),
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: dotenv.get('FIREBASE_IOS_API_KEY', fallback: ''),
        appId: dotenv.get('FIREBASE_IOS_APP_ID', fallback: ''),
        messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID', fallback: ''),
        projectId: dotenv.get('FIREBASE_PROJECT_ID', fallback: ''),
        storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET', fallback: ''),
        iosBundleId: dotenv.get('FIREBASE_IOS_BUNDLE_ID', fallback: ''),
      );

  static FirebaseOptions get macos => ios;
}
