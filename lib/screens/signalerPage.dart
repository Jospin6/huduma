import 'package:flutter/material.dart';
import 'package:huduma/utils/user_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignalerPage extends StatefulWidget {
  const SignalerPage({super.key});

  @override
  State<SignalerPage> createState() => _SignalerPageState();
}

class _SignalerPageState extends State<SignalerPage> {
  final _formKey = GlobalKey<FormState>();
  String? signalementType;
  String lieu = '';
  String ville = '';
  String description = '';
  XFile? photo;
  String? userUID;
  bool isLoading = false;

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
    'Insécurité',
    'Accident de la route',
    'Urgence médicale',
    'Incendies',
    'Catastrophe naturelle',
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Indicateur de chargement
      });

      try {
        // Créer un document dans la collection 'signalement'
        await FirebaseFirestore.instance.collection('signalement').add({
          'userUID': userUID,
          'type': signalementType,
          'lieu': lieu,
          'ville': ville,
          'description': description,
          'photo': photo
              ?.path, // Vous pouvez stocker le chemin de la photo ou l'URL après l'avoir téléchargée
          'timestamp': FieldValue.serverTimestamp(), // Ajouter un timestamp
        });

        // Créer un document dans la collection 'notifications'
        await FirebaseFirestore.instance.collection('notifications').add({
          'titre': signalementType,
          'contenu': description,
          'timestamp': FieldValue.serverTimestamp(), // Ajouter un timestamp
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signalement soumis avec succès!')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi: $e')),
        );
      } finally {
        setState(() {
          isLoading = false; // Arrêter l'indicateur de chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 30, right: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Type de signalement'),
              value: signalementType,
              items: signalementTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.white),
                  ),
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
              decoration: const InputDecoration(labelText: 'Lieu'),
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
              decoration: const InputDecoration(labelText: 'Ville'),
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
              decoration: const InputDecoration(labelText: 'Description'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text(
                'Ajouter une photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (photo != null)
              Text(
                'Photo sélectionnée: ${photo!.name}',
                style: const TextStyle(color: Colors.white),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 35,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : _submitForm, // Désactiver le bouton pendant le chargement
                child: isLoading
                    ? const CircularProgressIndicator() // Indicateur de chargement sur le bouton
                    : const Text(
                        'Soumettre le signalement',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
