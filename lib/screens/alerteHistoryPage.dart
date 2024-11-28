import 'package:flutter/material.dart';

class AlertHistoryPage extends StatelessWidget {
  final List<String> alerts = [
    "Alerte 1 : Système mis à jour",
    "Alerte 2 : Nouvelle notification reçue",
    "Alerte 3 : Rappel de réunion",
    "Alerte 4 : Mises à jour disponibles",
    "Alerte 5 : Alerte de sécurité",
    // Ajoutez d'autres alertes ici
  ];

    AlertHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Alertes'),
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(alerts[index]),
            leading: Icon(Icons.notifications),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Action à effectuer lors du clic sur l'alerte
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vous avez cliqué sur ${alerts[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}