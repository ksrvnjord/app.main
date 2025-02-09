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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBe3CUxnME526a4-NSlVuW9rbCehqnZdhk',
    appId: '1:755032766973:web:27289baa641d0ca44e0194',
    messagingSenderId: '755032766973',
    projectId: 'ksrv-njord',
    authDomain: 'ksrv-njord.firebaseapp.com',
    databaseURL:
        'https://ksrv-njord-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'ksrv-njord.appspot.com',
    measurementId: 'G-N451DV963D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBH2rrRJ_eTcolF3bJIyEYSI66J-mbnBik',
    appId: '1:755032766973:android:45155b9d8c89e6204e0194',
    messagingSenderId: '755032766973',
    projectId: 'ksrv-njord',
    databaseURL:
        'https://ksrv-njord-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'ksrv-njord.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmj4F9jJP22w0XpmBNoWsPurnrbN1KMWY',
    appId: '1:755032766973:ios:c70e32ff733792ca4e0194',
    messagingSenderId: '755032766973',
    projectId: 'ksrv-njord',
    databaseURL:
        'https://ksrv-njord-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'ksrv-njord.appspot.com',
    iosClientId:
        '755032766973-kso20cqedhltbrii1o22jod6i7lpptc7.apps.googleusercontent.com',
    iosBundleId: 'com.ksrvnjord.app',
  );
}
