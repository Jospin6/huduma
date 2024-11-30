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
      'title': 'Insécurité',
      'image': 'assets/images/ins.png',
    },
    {
      'title': 'Accident de la route',
      'image': 'assets/images/acc.png',
    },
    {
      'title': 'Urgence médicale',
      'image': 'assets/images/med.png',
    },
    {
      'title': 'Incendies',
      'image': 'assets/images/incendie.png',
    },
    {
      'title': 'Agression / Violences',
      'image': 'assets/images/viol.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
        itemCount: emergencyOptions.length,
        itemBuilder: (context, index) {
          final option = emergencyOptions[index];
          return Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(option['image']!),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                const Positioned(top: 10, right: 10, child: Text("Appeler")),
                Positioned(bottom: 10, left: 10, child: Text(option['title']!)),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}
