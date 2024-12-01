import 'package:flutter/material.dart';
import 'package:huduma/screens/widgets/alerteAppelWidget.dart';
import 'package:huduma/screens/widgets/expansionTextWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/utils/user_preferences.dart';

class DetailPage extends StatefulWidget {
  final Map<String, String> emergencyDetail;

  const DetailPage(this.emergencyDetail, {super.key});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> gestesProtection = [];
  String? userUID;

  @override
  void initState() {
    super.initState();
    _loadUserUID();
    _fetchGesteProtection();
  }

  Future<void> _loadUserUID() async {
    userUID =
        await UserPreferences.getUserUID(); // Utiliser la classe utilitaire
    setState(() {});
  }

  Future<void> _fetchGesteProtection() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('geste_protection')
        .where('titre', isEqualTo: widget.emergencyDetail['title']) // Filtrer par titre
        .get();

    List<Map<String, dynamic>> tempGestes = [];
    for (var doc in snapshot.docs) {
      tempGestes.add(doc.data() as Map<String, dynamic>);
    }

    setState(() {
      gestesProtection = tempGestes;
    });
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
                  AlerteAppelWidget(userUID: userUID!, option: widget.emergencyDetail),
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
                ),
                child: Column(
                  children: [
                    Text(
                      widget.emergencyDetail['details']!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Affichage des gestes de protection
                    Expanded(
                      child: gestesProtection.isEmpty
                          ? const Center(child: Text('Aucun geste de protection trouvé.'))
                          : ListView.builder(
                              itemCount: gestesProtection.length,
                              itemBuilder: (context, index) {
                                final geste = gestesProtection[index];
                                return ExpansionTextWidget(
                                  titre: geste['titre'] ?? 'Titre inconnu',
                                  description: geste['description'] ?? 'Aucune description',
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