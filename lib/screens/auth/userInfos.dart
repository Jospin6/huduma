import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/screens/homePage.dart';

class UserInfos extends StatefulWidget {
  final String uid;

  const UserInfos({super.key, required this.uid});

  @override
  _UserInfosState createState() => _UserInfosState();
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
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        print(e); // Gérer les erreurs ici
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la soumission du formulaire')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Étape 2: Informations supplémentaires')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Âge'),
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
                decoration: InputDecoration(labelText: 'Sexe'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm, // Appeler la méthode de soumission
                child: Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}