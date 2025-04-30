import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbmHx1Jv_ZrFlC857x7fCt9LNwCtN4waY',
    appId: '1:265146762202:android:58d554662fac7035ea76e3',
    messagingSenderId: '265146762202',
    projectId: 'conversor-flutter-1f587',
    storageBucket: 'conversor-flutter-1f587.firebasestorage.app'
  );
}
