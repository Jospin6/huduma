import 'package:flutter/material.dart';
import 'package:huduma/screens/alertePage.dart';
import 'package:huduma/screens/widgets/alerteAppelWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/screens/widgets/expansionTextWidget.dart';
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
          .where('titre', isEqualTo: widget.option['title'])
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
        title: Text(title, style: const TextStyle(color: Colors.white),),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
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
                      IconButton(onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlertePage(title: title)),
                          );
                      }, icon: const Icon(Icons.alarm, color: Colors.red,)),
                      AlerteAppelWidget(
                        userUID: userUID ?? 'UID par défaut', // Gestion de userUID
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
                  color: Colors.white, // Ajout d'une couleur de fond
                ),
                child: Column(
                  children: [
                    // Indicateur de chargement
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                    // Affichage des gestes de protection
                    Expanded(
                      child: gestesProtection.isEmpty && !isLoading
                          ? const Center(
                              child: Text('Aucun geste de protection trouvé.', style: TextStyle(color: Colors.white),))
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
