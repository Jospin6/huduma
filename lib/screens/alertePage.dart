import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertePage extends StatefulWidget {
  final String title;
  const AlertePage({super.key, required this.title});

  @override
  State<AlertePage> createState() => _AlertePageState();
}

class _AlertePageState extends State<AlertePage> {
  List<Map<String, dynamic>> alerts = [];

  @override
  void initState() {
    super.initState();
    _fetchAlerts();
  }

  Future<void> _fetchAlerts() async {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: alerts.isEmpty
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
                            'Utilisateur : $userName\nDate : ${alert['date'].toDate()}'),
                        leading: const Icon(Icons.notifications),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Vous avez cliqué sur ${alert['title']}')),
                          );
                        },
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                location['latitude'], location['longitude']),
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('alertLocation'),
                              position: LatLng(
                                  location['latitude'], location['longitude']),
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
