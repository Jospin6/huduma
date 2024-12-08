import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/utils/user_preferences.dart';
import 'package:intl/intl.dart'; // Importer pour formater les dates

class AlertHistoryPage extends StatefulWidget {
  const AlertHistoryPage({super.key});

  @override
  State<AlertHistoryPage> createState() => _AlertHistoryPageState();
}

class _AlertHistoryPageState extends State<AlertHistoryPage> {
  String? userUID;
  List<Map<String, dynamic>> alerts = [];
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _loadUserUID();
  }

  Future<void> _loadUserUID() async {
    userUID = await UserPreferences.getUserUID();
    if (userUID != null) {
      await _fetchAlerts();
    }
  }

  Future<void> _fetchAlerts() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('alerte_urgence')
          .where('userUID', isEqualTo: userUID)
          .get();

      setState(() {
        alerts = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>
          };
        }).toList();
        isLoading = false; // Fin du chargement
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Fin du chargement même en cas d'erreur
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des alertes: $e', style: const TextStyle(color: Colors.white),)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicateur de chargement
          : alerts.isEmpty
              ? const Center(child: Text('Aucune alerte trouvée.'))
              : ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(alerts[index]['title'], style: const TextStyle(color: Colors.white),),
                      subtitle: Text('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(alerts[index]['date'].toDate())}', style: const TextStyle(color: Colors.white),), // Formatage de la date
                      leading: const Icon(Icons.notifications, color: Colors.white,),
                      trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vous avez cliqué sur ${alerts[index]['title']}', style: const TextStyle(color: Colors.white),)),
                        );
                      },
                    );
                  },
                ),
    );
  }
}