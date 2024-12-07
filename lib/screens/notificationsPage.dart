import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
        title: const Text('Notifications', style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des notifications...', style: TextStyle(color: Colors.white),),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur lors du chargement des notifications: ${snapshot.error}', style: const TextStyle(color: Colors.white),),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune notification disponible.', style: TextStyle(color: Colors.white),));
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title.isNotEmpty ? title[0] : '?', // Première lettre du titre
                    style: const TextStyle(color: Colors.white, fontSize: 20,),
                  ),
                ),
                title: Text(title, style: const TextStyle(color: Colors.white),),
                subtitle: Text(content, style: const TextStyle(color: Colors.white),),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vous avez cliqué sur $title', style: const TextStyle(color: Colors.white),)),
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