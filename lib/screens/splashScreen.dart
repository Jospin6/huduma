import 'package:flutter/material.dart';
import 'package:huduma/myApp.dart';
import 'package:huduma/screens/auth/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userUID;

  @override
  void initState() {
    super.initState();
    _loadUserUID();
  }

  Future<void> _loadUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUID = prefs.getString('userUID'); // Récupérer le userUID

    // Attendre quelques secondes pour simuler le chargement
    await Future.delayed(const Duration(seconds: 2));

    // Naviguer vers la bonne page
    if (userUID != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()), 
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(), // Indicateur de chargement
      ),
    );
  }
}