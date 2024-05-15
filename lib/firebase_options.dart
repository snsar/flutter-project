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
    apiKey: 'AIzaSyBdLO85CV1FUp4q4EzjYVhv62g_kl-MESc',
    appId: '1:62401216641:web:537c67d472604264308d80',
    messagingSenderId: '62401216641',
    projectId: 'android-authen-flutter',
    authDomain: 'android-authen-flutter.firebaseapp.com',
    storageBucket: 'android-authen-flutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8Dyg1F2nOgsPhF_K5VjakghhkkWUoEIE',
    appId: '1:62401216641:android:b9e26616d54b3b9d308d80',
    messagingSenderId: '62401216641',
    projectId: 'android-authen-flutter',
    storageBucket: 'android-authen-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZ2qSKzef8p64p8cTs0KpKO9LlhKaNz6E',
    appId: '1:62401216641:ios:9d53908636f6106e308d80',
    messagingSenderId: '62401216641',
    projectId: 'android-authen-flutter',
    storageBucket: 'android-authen-flutter.appspot.com',
    iosBundleId: 'com.example.queyndz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZ2qSKzef8p64p8cTs0KpKO9LlhKaNz6E',
    appId: '1:62401216641:ios:9d53908636f6106e308d80',
    messagingSenderId: '62401216641',
    projectId: 'android-authen-flutter',
    storageBucket: 'android-authen-flutter.appspot.com',
    iosBundleId: 'com.example.queyndz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdLO85CV1FUp4q4EzjYVhv62g_kl-MESc',
    appId: '1:62401216641:web:28ce17ddaba9e93b308d80',
    messagingSenderId: '62401216641',
    projectId: 'android-authen-flutter',
    authDomain: 'android-authen-flutter.firebaseapp.com',
    storageBucket: 'android-authen-flutter.appspot.com',
  );
}
