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
    apiKey: 'your apikey',
    appId: '1:363564566380:web:34a12427e1c72a14fc9549',
    messagingSenderId: '363564566380',
    projectId: 'alpha-988cc',
    authDomain: 'alpha-988cc.firebaseapp.com',
    storageBucket: 'alpha-988cc.appspot.com',
    measurementId: 'G-2XGL2TC2NX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'Your API key',
    appId: '1:363564566380:android:61719df0b9ec109dfc9549',
    messagingSenderId: '363564566380',
    projectId: 'alpha-988cc',
    storageBucket: 'alpha-988cc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your API key',
    appId: '1:363564566380:ios:456a99c659b5d765fc9549',
    messagingSenderId: '363564566380',
    projectId: 'alpha-988cc',
    storageBucket: 'alpha-988cc.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'your API key',
    appId: '1:363564566380:ios:456a99c659b5d765fc9549',
    messagingSenderId: '363564566380',
    projectId: 'alpha-988cc',
    storageBucket: 'alpha-988cc.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'your API key',
    appId: '1:363564566380:web:66d0cb4c8b3f66d0fc9549',
    messagingSenderId: '363564566380',
    projectId: 'alpha-988cc',
    authDomain: 'alpha-988cc.firebaseapp.com',
    storageBucket: 'alpha-988cc.appspot.com',
    measurementId: 'G-B5MNH43KVZ',
  );
}
