import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications = [
    "Notification 1 : Mise à jour système disponible",
    "Notification 2 : Nouvelle alerte de sécurité",
    "Notification 3 : Rappel de maintenance planifiée",
    "Notification 4 : Changement de politique",
    "Notification 5 : Événement à venir",
    // Ajoutez d'autres notifications ici
  ];

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Action à effectuer lors du clic sur la notification
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vous avez cliqué sur ${notifications[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}