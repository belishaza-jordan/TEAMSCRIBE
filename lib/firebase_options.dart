import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for TeamScribe.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:            'AIzaSyAH0TzB8hJKz1vj2azpHRYPJQCpmz-1hNw',
    appId:             '1:468005640132:android:ea34bc1a595f8a82b27691',
    messagingSenderId: '468005640132',
    projectId:         'team-scribe',
    storageBucket:     'team-scribe.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:            'AIzaSyC8WhCFidZYSmGFWzZnXA0YczDf-XOv3Zo',
    appId:             '1:468005640132:ios:61c709ad57f7c013b27691',
    messagingSenderId: '468005640132',
    projectId:         'team-scribe',
    storageBucket:     'team-scribe.firebasestorage.app',
    iosBundleId:       'com.belishaza.teamscribe',
  );
}
