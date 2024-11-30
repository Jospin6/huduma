import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController locationController = TextEditingController();
  String? selectedType;
  List<String> suggestions = [];
  List<String> allLocations = [
    'Centre-ville', 'Quartier Nord', 'Avenue des Champs', 'Rue de la Paix',
    'Avenue Victor Hugo', 'Quartier Sud', 'Rue du Faubourg', 'Avenue de la République'
  ];
  
  final List<String> emergencyTypes = [
    'Accident de la route',
    'Incendie',
    'Urgence médicale',
    'Vol',
    'Autre',
  ];

  List<XFile>? _imageFiles = []; // Liste pour stocker les images

  void updateSuggestions(String input) {
    if (input.isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    setState(() {
      suggestions = allLocations.where((location) => location.toLowerCase().contains(input.toLowerCase())).toList();
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(); // Choisir plusieurs images

    if (pickedFiles != null) {
      setState(() {
        _imageFiles!.addAll(pickedFiles); // Ajouter les images à la liste
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faire un Signalement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type d\'urgence:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              hint: Text('Sélectionnez un type'),
              value: selectedType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedType = newValue;
                });
              },
              items: emergencyTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Localisation:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez la localisation',
              ),
              onChanged: updateSuggestions,
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    locationController.text = suggestions[index];
                    setState(() {
                      suggestions = [];
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Ajouter des Photos'),
            ),
            SizedBox(height: 10),
            // Affichage des images sélectionnées
            _imageFiles != null && _imageFiles!.isNotEmpty
              ? Wrap(
                  spacing: 8.0,
                  children: _imageFiles!.map((image) {
                    return Image.file(
                      File(image.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                )
              : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String location = locationController.text;
                print('Signalement: Type - $selectedType, Localisation - $location, Images - ${_imageFiles?.map((file) => file.path)}');

                // Retourner à la page précédente
                Navigator.pop(context);
              },
              child: Text('Envoyer le Signalement'),
            ),
          ],
        ),
      ),
    );
  }
}