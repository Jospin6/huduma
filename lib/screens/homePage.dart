import 'package:flutter/material.dart';
import 'package:huduma/screens/contactsPage.dart';
import 'package:huduma/screens/detailPage.dart';
import 'package:huduma/screens/widgets/alerteAppelWidget.dart';
import 'package:huduma/utils/emergency_options.dart';
import 'package:huduma/utils/user_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userUID;
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _loadUserUID();
  }

  Future<void> _loadUserUID() async {
    try {
      userUID = await UserPreferences.getUserUID(); // Utiliser la classe utilitaire
    } catch (e) {
      print('Erreur lors de la récupération de l\'UID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération de l\'UID.')),
      );
    } finally {
      setState(() {
        isLoading = false; // Fin du chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactsPage()),
              );
            },
            child: const Text('Alertes'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
                : ListView.builder(
                    itemCount: emergencyOptions.length,
                    shrinkWrap: true, // Pour éviter les erreurs de taille
                    physics: NeverScrollableScrollPhysics(), // Désactiver le défilement
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
                              child: userUID != null // Vérification de l'UID
                                  ? AlerteAppelWidget(userUID: userUID!, option: option)
                                  : Container(),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(option),
                                    ),
                                  );
                                },
                                child: Text(
                                  option['title']!,
                                  style: TextStyle(color: Colors.white, fontSize: 18), // Amélioration de l'accessibilité
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}