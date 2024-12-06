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
    try {
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
    } catch (e) {
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des données: $e')),
      );
      // Naviguer vers la page principale en cas d'erreur
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Indicateur de chargement
            SizedBox(height: 20),
            Text('Chargement...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}