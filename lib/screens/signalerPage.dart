import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Logique pour soumettre le formulaire
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signalement soumis avec succès!')),
                  );
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
