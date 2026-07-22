import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgLUKie55R8Sl--2g1pB4sk1TyGFGp4Do',
    appId: '1:950174705067:android:a98bfca8c77869d6359eee',
    messagingSenderId: '950174705067',
    projectId: 'app-store-cb122',
    storageBucket: 'app-store-cb122.firebasestorage.app',
  );
}
