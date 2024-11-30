import 'package:flutter/material.dart';
import 'package:huduma/utils/user_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignalerPage extends StatefulWidget {
  @override
  _SignalerPageState createState() => _SignalerPageState();
}

class _SignalerPageState extends State<SignalerPage> {
  final _formKey = GlobalKey<FormState>();
  String? signalementType;
  String lieu = '';
  String ville = '';
  String description = '';
  XFile? photo;

  String? userUID;

  @override
  void initState() {
    super.initState();
    _loadUserUID();
  }

  Future<void> _loadUserUID() async {
    userUID =
        await UserPreferences.getUserUID(); // Utiliser la classe utilitaire
    setState(() {});
  }

  final List<String> signalementTypes = [
    'Accident',
    'Agression',
    'Viol',
    'Incendie',
    'Catastrophe naturelle',
  ];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    photo = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Type de signalement'),
              value: signalementType,
              items: signalementTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  signalementType = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Veuillez sélectionner un type de signalement';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Lieu'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le lieu';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  lieu = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Ville'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la ville';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  ville = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une description';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Ajouter une photo'),
            ),
            if (photo != null) Text('Photo sélectionnée: ${photo!.name}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Créer un document dans la collection 'signalement'
                    await FirebaseFirestore.instance
                        .collection('signalement')
                        .add({
                      'userUID': userUID,
                      'type': signalementType,
                      'lieu': lieu,
                      'ville': ville,
                      'description': description,
                      'photo': photo
                          ?.path, // Vous pouvez stocker le chemin de la photo ou l'URL après l'avoir téléchargée
                      'timestamp':
                          FieldValue.serverTimestamp(), // Ajouter un timestamp
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Signalement soumis avec succès!')),
                    );

                    // Réinitialiser le formulaire ou naviguer ailleurs si nécessaire
                    _formKey.currentState!.reset();
                    setState(() {
                      signalementType = null;
                      lieu = '';
                      ville = '';
                      description = '';
                      photo = null;
                    });
                  } catch (e) {
                    print(e); // Gérer les erreurs ici
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erreur lors de la soumission: $e')),
                    );
                  }
                }
              },
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}
