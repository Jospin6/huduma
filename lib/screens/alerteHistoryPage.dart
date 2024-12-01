import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/utils/user_preferences.dart';

class AlertHistoryPage extends StatefulWidget {
  const AlertHistoryPage({super.key});

  @override
  State<AlertHistoryPage> createState() => _AlertHistoryPageState();
}

class _AlertHistoryPageState extends State<AlertHistoryPage> {
  String? userUID;
  List<Map<String, dynamic>> alerts = [];

  @override
  void initState() {
    super.initState();
    _loadUserUID();
  }

  Future<void> _loadUserUID() async {
    userUID = await UserPreferences.getUserUID(); // Utiliser la classe utilitaire
    if (userUID != null) {
      _fetchAlerts();
    }
  }

  Future<void> _fetchAlerts() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('alerte_urgence')
        .where('userUID', isEqualTo: userUID)
        .get();

    setState(() {
      alerts = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Alertes'),
      ),
      body: alerts.isEmpty
          ? const Center(child: Text('Aucune alerte trouvée.'))
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(alerts[index]['title']),
                  subtitle: Text('Date: ${alerts[index]['date'].toDate()}'),
                  leading: const Icon(Icons.notifications),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Action à effectuer lors du clic sur l'alerte
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vous avez cliqué sur ${alerts[index]['title']}')),
                    );
                  },
                );
              },
            ),
    );
  }
}