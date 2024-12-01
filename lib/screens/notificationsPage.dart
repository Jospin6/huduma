import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('notifications').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erreur lors du chargement des notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune notification disponible'));
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    title.isNotEmpty
                        ? title[0]
                        : '?', // Première lettre du titre
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
