import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> emergencyOptions = [
    {
      'title': 'Appel d\'urgence',
      'image': 'https://example.com/image1.jpg', // Remplacez par votre URL d'image
    },
    {
      'title': 'Ambulance',
      'image': 'https://example.com/image2.jpg', // Remplacez par votre URL d'image
    },
    {
      'title': 'Pompiers',
      'image': 'https://example.com/image3.jpg', // Remplacez par votre URL d'image
    },
    {
      'title': 'Police',
      'image': 'https://example.com/image4.jpg', // Remplacez par votre URL d'image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil - Urgences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Nombre de colonnes
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: emergencyOptions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Action à effectuer lors du tap sur une option
                print('Option sélectionnée: ${emergencyOptions[index]['title']}');
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(emergencyOptions[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54, // Couleur de fond semi-transparente
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    emergencyOptions[index]['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}