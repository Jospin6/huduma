import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  List<Map<String, dynamic>> signalements = [];

  @override
  void initState() {
    super.initState();
    _fetchSignalements();
  }

  Future<void> _fetchSignalements() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('signalement')
        .get();

    List<Map<String, dynamic>> tempSignalements = [];
    for (var doc in snapshot.docs) {
      tempSignalements.add(doc.data() as Map<String, dynamic>);
    }

    setState(() {
      signalements = tempSignalements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signalements'),
      ),
      body: signalements.isEmpty
          ? const Center(child: Text('Aucun signalement trouvé.'))
          : ListView.builder(
              itemCount: signalements.length,
              itemBuilder: (context, index) {
                final signalement = signalements[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre de la Card
                        Text(
                          signalement['type'] ?? 'Type inconnu',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10), // Espacement

                        // Column pour lieu, ville, commune
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lieu: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              signalement['lieu'] ?? 'Lieu inconnu',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5), // Espacement

                            Text(
                              'Ville: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              signalement['ville'] ?? 'Ville inconnue',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5), // Espacement

                            Text(
                              'Description: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              signalement['description'] ?? 'Aucune description',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Espacement

                        // Image
                        if (signalement['photo'] != null) 
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(signalement['photo']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}