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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 80, 37, 153)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
