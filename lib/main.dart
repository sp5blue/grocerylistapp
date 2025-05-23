import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery_list_app/firebase_options.dart';
import 'package:grocery_list_app/pages/auth_gate.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_list_app/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}
