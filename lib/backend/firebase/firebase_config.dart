import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDrEEfR9K5La05Ce-zid35vxnrm2OSzy1E",
            authDomain: "prod-audit-7gehwd.firebaseapp.com",
            projectId: "prod-audit-7gehwd",
            storageBucket: "prod-audit-7gehwd.appspot.com",
            messagingSenderId: "581824486717",
            appId: "1:581824486717:web:de90ce65d7ebd183903954"));
  } else {
    await Firebase.initializeApp();
  }
}
