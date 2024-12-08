import 'package:flutter/material.dart';
import 'package:huduma/screens/alertePage.dart';
import 'package:huduma/screens/widgets/alerteAppelWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/utils/user_preferences.dart';

class DetailPage extends StatefulWidget {
  final Map<String, String> option;

  const DetailPage({super.key, required this.option});

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
          .where('type_urgence', isEqualTo: widget.option['title'])
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
        SnackBar(
            content: Text('Erreur lors de la récupération des gestes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vérifiez les valeurs nulles pour 'title' et 'image'
    String title = widget.option['title'] ?? 'Titre inconu';
    String image = widget.option['image'] ?? 'assets/images/viol.png';

    return Scaffold(
        appBar: AppBar(
          title: Text(title, style: const TextStyle(color: Colors.white)),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlertePage(title: title),
                              ),
                            );
                          },
                          icon: const Icon(Icons.alarm, color: Colors.red),
                        ),
                        AlerteAppelWidget(
                          userUID:
                              userUID ?? 'UID par défaut', // Gestion de userUID
                          option: widget.option,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 150,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    color: Colors.black, // Ajout d'une couleur de fond
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Indicateur de chargement
                        if (isLoading)
                          const Center(child: CircularProgressIndicator()),
                        // Affichage des gestes de protection
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: gestesProtection.isEmpty && !isLoading
                              ? const Center(
                                  child: Text(
                                    'Aucun geste de protection trouvé.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: gestesProtection.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final geste = gestesProtection[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            // Colonne de droite pour l'image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                geste['image'] ?? '',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  return const Icon(Icons.image,
                                                      color: Color.fromARGB(255, 207, 204, 204)); // Affiche une icône d'erreur
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // Colonne de gauche pour le titre et la description
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    geste['titre'] ??
                                                        'Titre inconnu',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    geste['description'] ??
                                                        'Aucune description',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
