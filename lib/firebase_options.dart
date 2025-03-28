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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7pMrnmfp2fYxlIKRsutOM1B_BEvMeK2c',
    appId: '1:953917883604:android:3e9575857b85316f036741',
    messagingSenderId: '953917883604',
    projectId: 'animal-help-app-96e6a',
    storageBucket: 'animal-help-app-96e6a.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAB7_n_ryyMj3fxoy62-5zdnBWG83ThF2M',
    appId: '1:953917883604:web:5e22d1fa54a98b7d036741',
    messagingSenderId: '953917883604',
    projectId: 'animal-help-app-96e6a',
    authDomain: 'animal-help-app-96e6a.firebaseapp.com',
    storageBucket: 'animal-help-app-96e6a.firebasestorage.app',
    measurementId: 'G-4FZP9DEED3',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAB7_n_ryyMj3fxoy62-5zdnBWG83ThF2M',
    appId: '1:953917883604:web:5e22d1fa54a98b7d036741',
    messagingSenderId: '953917883604',
    projectId: 'animal-help-app-96e6a',
    authDomain: 'animal-help-app-96e6a.firebaseapp.com',
    storageBucket: 'animal-help-app-96e6a.firebasestorage.app',
    measurementId: 'G-4FZP9DEED3',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdkHhO05uvRHGGWmlNptR54DeInjq5pCE',
    appId: '1:953917883604:ios:c1a65e3582e4f4a3036741',
    messagingSenderId: '953917883604',
    projectId: 'animal-help-app-96e6a',
    storageBucket: 'animal-help-app-96e6a.firebasestorage.app',
    iosBundleId: 'com.example.animalApp',
  );

}