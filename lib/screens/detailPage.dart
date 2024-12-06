import 'package:flutter/material.dart';
import 'package:huduma/screens/alertePage.dart';
import 'package:huduma/screens/widgets/alerteAppelWidget.dart';
import 'package:huduma/screens/widgets/expansionTextWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/utils/user_preferences.dart';

class DetailPage extends StatefulWidget {
  final Map<String, String> emergencyDetail;

  const DetailPage(this.emergencyDetail, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> gestesProtection = [];
  String? userUID;
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _loadUserUID();
    _fetchGesteProtection();
  }

  Future<void> _loadUserUID() async {
    userUID = await UserPreferences.getUserUID();
    setState(() {});
  }

  Future<void> _fetchGesteProtection() async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('geste_protection')
        .where('titre', isEqualTo: widget.emergencyDetail['title'])
        .get();

    List<Map<String, dynamic>> tempGestes = [];
    for (var doc in snapshot.docs) {
      tempGestes.add(doc.data() as Map<String, dynamic>);
    }

    setState(() {
      gestesProtection = tempGestes;
      isLoading = false;
    });
  } catch (e) {
    print('Erreur lors de la récupération des gestes: $e');
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la récupération des gestes: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.emergencyDetail['title']!),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.emergencyDetail['image']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        widget.emergencyDetail['title']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlertePage(
                                    title: widget.emergencyDetail['title']!)),
                          );
                        },
                        child: const Text('Alertes'),
                      ),
                      AlerteAppelWidget(
                          userUID: userUID!, option: widget.emergencyDetail),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white, // Ajout d'une couleur de fond
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.emergencyDetail['details']!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    // Indicateur de chargement
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                    // Affichage des gestes de protection
                    Expanded(
                      child: gestesProtection.isEmpty && !isLoading
                          ? const Center(
                              child: Text('Aucun geste de protection trouvé.'))
                          : ListView.builder(
                              itemCount: gestesProtection.length,
                              itemBuilder: (context, index) {
                                final geste = gestesProtection[index];
                                return ExpansionTextWidget(
                                  titre: geste['titre'] ?? 'Titre inconnu',
                                  description: geste['description'] ??
                                      'Aucune description',
                                  image: geste['image'] ?? '',
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}