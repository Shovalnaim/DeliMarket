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
      return android;
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

  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyBayKPTk4t3VJ9wJtm8jJ7N7dym49pjhb4',
  //   appId: '1:77154410269:web:337583dbeb1510b4a8cbf4',
  //   messagingSenderId: '77154410269',
  //   projectId: 'market-2ffe3',
  //   authDomain: 'market-2ffe3.firebaseapp.com',
  //   storageBucket: 'market-2ffe3.appspot.com',
  //  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJLdZH0tVVytYxRGTFz_uWTG0UWsM3ieg',
    appId: '1:77154410269:android:3497db8a6ca7cecda8cbf4',
    messagingSenderId: '77154410269',
    projectId: 'market-2ffe3',
    storageBucket: 'market-2ffe3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPFYY_3jBK1BbIA-G6s44DaPuWHziLLro',
    appId: '1:77154410269:ios:11e76b127c025b76a8cbf4',
    messagingSenderId: '77154410269',
    projectId: 'market-2ffe3',
    storageBucket: 'market-2ffe3.appspot.com',
    iosBundleId: 'com.example.markettest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPFYY_3jBK1BbIA-G6s44DaPuWHziLLro',
    appId: '1:77154410269:ios:b80bf3b727df0967a8cbf4',
    messagingSenderId: '77154410269',
    projectId: 'market-2ffe3',
    storageBucket: 'market-2ffe3.appspot.com',
    iosBundleId: 'com.example.markettest.RunnerTests',
  );
}
