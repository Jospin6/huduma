import 'package:flutter/material.dart';
import 'package:huduma/screens/widgets/alerteAppelWidget.dart';
import 'package:huduma/utils/user_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  final List<Map<String, String>> emergencyOptions = [
    {
      'title': 'Insécurité',
      'image': 'assets/images/ins.png',
      'num_tele': '117'
    },
    {
      'title': 'Accident de la route',
      'image': 'assets/images/acc.png',
      'num_tele': '112'
    },
    {
      'title': 'Urgence médicale',
      'image': 'assets/images/med.png',
      'num_tele': '116'
    },
    {
      'title': 'Incendies',
      'image': 'assets/images/incendie.png',
      'num_tele': '118'
    },
    {
      'title': 'Agression / Violences',
      'image': 'assets/images/viol.png',
      'num_tele': '117'
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: AlerteAppelWidget(userUID: userUID!, option: option),
                  ),
                  Positioned(
                      bottom: 10, left: 10, child: Text(option['title']!)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
