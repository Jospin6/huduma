import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InformationsForm extends StatefulWidget {
  const InformationsForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InformationsFormState createState() => _InformationsFormState();
}

class _InformationsFormState extends State<InformationsForm> {
  final _formKey = GlobalKey<FormState>();
  String? incidentType;
  String title = '';
  String content = '';
  XFile? photo;

  final List<String> incidentTypes = [
    'Accident',
    'Agression',
    'Viol',
    'Incendie',
    'Catastrophe naturelle',
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulaire d\'Informations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Type d\'incident'),
                value: incidentType,
                items: incidentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    incidentType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un type d\'incident';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contenu'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un contenu';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    content = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Ajouter une photo'),
              ),
              if (photo != null) 
                Text('Photo sélectionnée: ${photo!.name}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logique pour soumettre le formulaire
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Informations soumises avec succès!')),
                    );
                  }
                },
                child: const Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}