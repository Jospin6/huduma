import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:huduma/myApp.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}