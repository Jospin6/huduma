// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCly8bKno9DbcgRo1oRZ3DQLy-jUWCiZ2s',
    appId: '1:491776635494:web:dc2f04645336e9b80e73a7',
    messagingSenderId: '491776635494',
    projectId: 'huduma-6c21f',
    authDomain: 'huduma-6c21f.firebaseapp.com',
    storageBucket: 'huduma-6c21f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIf--T0q7hIIRNjXrprC3Xih78Z9HDKrA',
    appId: '1:491776635494:android:baf7efe713b29b5b0e73a7',
    messagingSenderId: '491776635494',
    projectId: 'huduma-6c21f',
    storageBucket: 'huduma-6c21f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJmPWEimuPcDGNK3oGBOAYt0ebUAgWWss',
    appId: '1:491776635494:ios:e41b9cbd3825868c0e73a7',
    messagingSenderId: '491776635494',
    projectId: 'huduma-6c21f',
    storageBucket: 'huduma-6c21f.firebasestorage.app',
    iosBundleId: 'com.example.huduma',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJmPWEimuPcDGNK3oGBOAYt0ebUAgWWss',
    appId: '1:491776635494:ios:e41b9cbd3825868c0e73a7',
    messagingSenderId: '491776635494',
    projectId: 'huduma-6c21f',
    storageBucket: 'huduma-6c21f.firebasestorage.app',
    iosBundleId: 'com.example.huduma',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCly8bKno9DbcgRo1oRZ3DQLy-jUWCiZ2s',
    appId: '1:491776635494:web:92e303f6a5f979810e73a7',
    messagingSenderId: '491776635494',
    projectId: 'huduma-6c21f',
    authDomain: 'huduma-6c21f.firebaseapp.com',
    storageBucket: 'huduma-6c21f.firebasestorage.app',
  );
}
