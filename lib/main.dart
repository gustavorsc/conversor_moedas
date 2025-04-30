import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDcVSX9PxBcwoPAKBGNa1xDprGYxJjBEWc",
        authDomain: "conversor-flutter-1f587.firebaseapp.com",
        projectId: "conversor-flutter-1f587",
        storageBucket: "conversor-flutter-1f587.firebasestorage.app",
        messagingSenderId: "265146762202",
        appId: "1:265146762202:web:fd3f9b7e7876a303ea76e3"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
