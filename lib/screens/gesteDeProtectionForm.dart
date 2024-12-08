import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class GesteDeProtectionForm extends StatefulWidget {
  final String? typeUrgence;

  const GesteDeProtectionForm({super.key, required this.typeUrgence});

  @override
  State<GesteDeProtectionForm> createState() => _GesteDeProtectionFormState();
}

class _GesteDeProtectionFormState extends State<GesteDeProtectionForm> {
  final _formKey = GlobalKey<FormState>();
  String titre = '';
  String description = '';
  XFile? image;
  bool isLoading = false; // Indicateur de chargement

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && image != null) {
      setState(() {
        isLoading = true; // Démarrer le chargement
      });

      try {
        await FirebaseFirestore.instance.collection('geste_protection').add({
          'type_urgence': widget.typeUrgence,
          'titre': titre,
          'description': description,
          'image':
              image!.path, // Vous pouvez stocker l'URL après téléchargement
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Geste de protection soumis avec succès!')),
        );

        // Réinitialiser le formulaire
        _formKey.currentState!.reset();
        setState(() {
          titre = '';
          description = '';
          image = null;
          isLoading = false; // Fin du chargement
        });
      } catch (e) {
        setState(() {
          isLoading = false; // Fin du chargement en cas d'erreur
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Erreur lors de la soumission: $e',
            style: const TextStyle(color: Colors.white),
          )),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Veuillez remplir tous les champs et sélectionner une image.',
          style: TextStyle(color: Colors.white),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Geste de Protection',
        style: TextStyle(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre'),
                onChanged: (value) {
                  titre = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text(
                  'Sélectionner une image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              if (image != null)
                Text(
                  'Image sélectionnée: ${image!.name}',
                  style: const TextStyle(color: Colors.white),
                ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator() // Indicateur de chargement
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text(
                          'Valider',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
