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
    apiKey: 'AIzaSyC2ACYngXlT5wL-bGtGt7i6VvRMJPbCfso',
    appId: '1:837829830682:web:d24bcbfb1818919bfa09a3',
    messagingSenderId: '837829830682',
    projectId: 'vms-otp-5fe3f',
    authDomain: 'vms-otp-5fe3f.firebaseapp.com',
    storageBucket: 'vms-otp-5fe3f.firebasestorage.app',
    measurementId: 'G-6VWQBT7531',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpaNz66O0Azub2skBZbsNbW3OvJ0peums',
    appId: '1:837829830682:android:3e1f42923500200bfa09a3',
    messagingSenderId: '837829830682',
    projectId: 'vms-otp-5fe3f',
    storageBucket: 'vms-otp-5fe3f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtuDn6Tw7ZYNz8NSO0AFoKFQwQOvHyiT0',
    appId: '1:837829830682:ios:cac29a5ccda252bafa09a3',
    messagingSenderId: '837829830682',
    projectId: 'vms-otp-5fe3f',
    storageBucket: 'vms-otp-5fe3f.firebasestorage.app',
    iosBundleId: 'com.example.vmsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtuDn6Tw7ZYNz8NSO0AFoKFQwQOvHyiT0',
    appId: '1:837829830682:ios:cac29a5ccda252bafa09a3',
    messagingSenderId: '837829830682',
    projectId: 'vms-otp-5fe3f',
    storageBucket: 'vms-otp-5fe3f.firebasestorage.app',
    iosBundleId: 'com.example.vmsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2ACYngXlT5wL-bGtGt7i6VvRMJPbCfso',
    appId: '1:837829830682:web:d24bcbfb1818919bfa09a3',
    messagingSenderId: '837829830682',
    projectId: 'vms-otp-5fe3f',
    authDomain: 'vms-otp-5fe3f.firebaseapp.com',
    storageBucket: 'vms-otp-5fe3f.firebasestorage.app',
    measurementId: 'G-6VWQBT7531',
  );
}
