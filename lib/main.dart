import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:huduma/screens/splashScreen.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyPrincipalApp());
}

class MyPrincipalApp extends StatelessWidget {
  const MyPrincipalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Huduma',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
