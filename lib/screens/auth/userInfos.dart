import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/myApp.dart';

class UserInfos extends StatefulWidget {
  final String uid;

  const UserInfos({super.key, required this.uid});

  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  final _formKey = GlobalKey<FormState>();
  String age = '';
  String gender = 'Homme';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Enregistrer les informations supplémentaires dans Firestore
        await FirebaseFirestore.instance.collection('userInfos').doc(widget.uid).set({
          'age': age,
          'gender': gender,
        });

        // Rediriger vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      } catch (e) {
        print(e); // Gérer les erreurs ici
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la soumission du formulaire', style: TextStyle(color: Colors.white),)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informations supplémentaires', style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Âge'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre âge';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Sexe'),
                items: <String>['Homme', 'Femme', 'Autre']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm, // Appeler la méthode de soumission
                child: const Text('Soumettre', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}