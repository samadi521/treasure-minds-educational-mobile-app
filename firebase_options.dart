import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform not configured yet. Use Android instead.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS platform not configured yet. Use Android instead.');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS platform not configured yet. Use Android instead.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZ4h-5zHzNjxllGR3Im8_UEjunva1QBX4',
    appId: '1:207607486288:android:59742aaa4e815e14d93e55',
    messagingSenderId: '207607486288',
    projectId: 'treasure-minds',
    storageBucket: 'treasure-minds.firebasestorage.app',
  );
}