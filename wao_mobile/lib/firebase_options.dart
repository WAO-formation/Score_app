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
    apiKey: 'AIzaSyC1LvmPUXkOL6K-E191ACeWF0CXKQqryPg',
    appId: '1:633369671789:web:86f58e3b9e804e1a066764',
    messagingSenderId: '633369671789',
    projectId: 'wao-mobiel-app',
    authDomain: 'wao-mobiel-app.firebaseapp.com',
    storageBucket: 'wao-mobiel-app.appspot.com',
    measurementId: 'G-81X7HTKJC8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-BzbjolKBkPAPGc3rsvAnut4eLmdOa-I',
    appId: '1:633369671789:android:871d7b1bfe4a1f30066764',
    messagingSenderId: '633369671789',
    projectId: 'wao-mobiel-app',
    storageBucket: 'wao-mobiel-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtKceb1ePFDG400tjDHZU6eo_8QSVgd1k',
    appId: '1:633369671789:ios:d591337eb07a42a8066764',
    messagingSenderId: '633369671789',
    projectId: 'wao-mobiel-app',
    storageBucket: 'wao-mobiel-app.appspot.com',
    iosClientId: '633369671789-antufu0i6b82i39ohfc5afv49ip4fe8a.apps.googleusercontent.com',
    iosBundleId: 'com.example.waoMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtKceb1ePFDG400tjDHZU6eo_8QSVgd1k',
    appId: '1:633369671789:ios:d591337eb07a42a8066764',
    messagingSenderId: '633369671789',
    projectId: 'wao-mobiel-app',
    storageBucket: 'wao-mobiel-app.appspot.com',
    iosClientId: '633369671789-antufu0i6b82i39ohfc5afv49ip4fe8a.apps.googleusercontent.com',
    iosBundleId: 'com.example.waoMobile',
  );
}
