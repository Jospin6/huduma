import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huduma/screens/gesteDeProtectionForm.dart';
import 'package:intl/intl.dart'; // Importer pour formater les dates

class AlertePage extends StatefulWidget {
  final String title;
  const AlertePage({super.key, required this.title});

  @override
  State<AlertePage> createState() => _AlertePageState();
}

class _AlertePageState extends State<AlertePage> {
  List<Map<String, dynamic>> alerts = [];
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchAlerts();
  }

  Future<void> _fetchAlerts() async {
    try {
      final QuerySnapshot alertSnapshot = await FirebaseFirestore.instance
          .collection('alerte_urgence')
          .where('title', isEqualTo: widget.title)
          .get();

      List<Map<String, dynamic>> tempAlerts = [];

      for (var alertDoc in alertSnapshot.docs) {
        final userUID = alertDoc['userUID'];
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userUID)
            .get();

        tempAlerts.add({
          'alertData': alertDoc.data(),
          'userName': userDoc.data()?['name'] ?? 'Nom inconnu',
          'location': alertDoc['location'], // Récupérer la localisation
        });
      }

      setState(() {
        alerts = tempAlerts;
        isLoading = false; // Fin du chargement
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Fin du chargement même en cas d'erreur
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des alertes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GesteDeProtectionForm(typeUrgence: widget.title),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicateur de chargement
          : alerts.isEmpty
              ? const Center(child: Text('Aucune alerte trouvée.'))
              : ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index]['alertData'];
                    final userName = alerts[index]['userName'];
                    final location = alerts[index]['location'];

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(alert['title']),
                            subtitle: Text(
                              'Utilisateur : $userName\nDate : ${DateFormat('dd/MM/yyyy HH:mm').format(alert['date'].toDate())}', // Formatage de la date
                            ),
                            leading: const Icon(Icons.notifications),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Vous avez cliqué sur ${alert['title']}'),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  location['latitude'],
                                  location['longitude'],
                                ),
                                zoom: 14,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('alertLocation'),
                                  position: LatLng(
                                    location['latitude'],
                                    location['longitude'],
                                  ),
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}