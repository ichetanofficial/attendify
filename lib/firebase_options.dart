// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCPhd4w4ensV5bp2rgv6adxOBs6SbFRH9U',
    appId: '1:683155465107:web:3ef441b4e12d59971efe66',
    messagingSenderId: '683155465107',
    projectId: 'attendify-34f84',
    authDomain: 'attendify-34f84.firebaseapp.com',
    storageBucket: 'attendify-34f84.appspot.com',
    measurementId: 'G-VX9JDEGJ88',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8AZTMi4gsxNJ_rdNBdEV9I_fDKRHjTeg',
    appId: '1:683155465107:android:516336ea24d73ddb1efe66',
    messagingSenderId: '683155465107',
    projectId: 'attendify-34f84',
    storageBucket: 'attendify-34f84.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8QwbglzpWv4xSPDCJYy9PqVD-p7LsYzs',
    appId: '1:683155465107:ios:dd6262c840d760591efe66',
    messagingSenderId: '683155465107',
    projectId: 'attendify-34f84',
    storageBucket: 'attendify-34f84.appspot.com',
    iosBundleId: 'com.codeascript.attendify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8QwbglzpWv4xSPDCJYy9PqVD-p7LsYzs',
    appId: '1:683155465107:ios:780331ee387cbc5e1efe66',
    messagingSenderId: '683155465107',
    projectId: 'attendify-34f84',
    storageBucket: 'attendify-34f84.appspot.com',
    iosBundleId: 'com.codeascript.attendify.RunnerTests',
  );
}
