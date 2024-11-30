import 'package:flutter/material.dart';

class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                // Titre de la Card
                const Text(
                  'Titre de la Card',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10), // Espacement

                // Column pour lieu, ville, commune
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lieu: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Kadutu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5), // Espacement

                    Text(
                      'Ville: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Goma',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5), // Espacement

                    Text(
                      'Commune: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Nyiragongo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Espacement

                // Description
                const Text(
                  'Voici une description de la Card, qui peut contenir des informations supplémentaires.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10), // Espacement

                // Image
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://via.placeholder.com/300'), // Remplacez par votre URL d'image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
