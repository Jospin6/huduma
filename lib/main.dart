import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:huduma/screens/splashScreen.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Huduma',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: const SplashScreen(),
  ));
}
