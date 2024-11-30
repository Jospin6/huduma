import 'package:flutter/material.dart';

class UserInfos extends StatefulWidget {
  const UserInfos({super.key});

  @override
  _UserInfosState createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  final _formKey = GlobalKey<FormState>();
  String age = '';
  String gender = 'Homme';

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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logique pour soumettre le formulaire
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Formulaire soumis avec succès!')),
                    );
                  }
                },
                child: Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}