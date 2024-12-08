import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/myApp.dart';
import 'package:huduma/screens/auth/userInfos.dart';
import 'package:huduma/utils/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String lastName = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _checkIfUserExists();
  }

  Future<void> _checkIfUserExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isUserRegistered = prefs.getBool('isUserRegistered') ?? false;

    if (isUserRegistered) {
      // Naviguez vers la page principale si l'utilisateur est déjà enregistré
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyApp()), // Placeholder
      );
    }
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Créer un compte anonyme
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        String uid = userCredential.user?.uid ?? '';

        // Stocker les informations de l'utilisateur dans Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'urgence': 'non'
        });

        // Enregistrer l'UID et l'état de l'utilisateur
        await UserPreferences.saveUserUID(uid); // Utiliser la classe utilitaire
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserRegistered', true);

        // Naviguer vers la page UserInfos avec l'UID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserInfos(uid: uid)),
        );
      } catch (e) {
        print(e); // Gérer les erreurs ici
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e', style: const TextStyle(color: Colors.white),)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enregistrer vos infos', style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Post-nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre post-nom';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerUser(); // Appeler la méthode d'enregistrement
                    }
                  },
                  child: const Text('Continuer', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
