import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('notifications').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Chargement des notifications...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur lors du chargement des notifications: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: const Text('Aucune notification disponible.'));
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final title = notification['titre'] ?? 'Titre inconnu';
              final content = notification['contenu'] ?? 'Contenu inconnu';

              return ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title.isNotEmpty ? title[0] : '?', // Première lettre du titre
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                title: Text(title),
                subtitle: Text(content),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vous avez cliqué sur $title')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}