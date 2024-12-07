import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> _alerts = []; // Liste des alertes

  void _addAlert(String alert) {
    setState(() {
      _alerts.add(alert);
    });
  }

  void _showAddAlertDialog() {
    String alertText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ajouter une Alerte'),
          content: TextField(
            onChanged: (value) {
              alertText = value;
            },
            decoration: const InputDecoration(labelText: 'Description de l\'alerte'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (alertText.isNotEmpty) {
                  _addAlert(alertText);
                  Navigator.of(context).pop(); // Ferme le popup après ajout
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard d\'Urgence'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre principal
            const Text(
              'Bienvenue dans votre Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Cartes d'alertes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAlertCard('Alertes Actuelles', _alerts.length.toString(), Colors.orange),
                _buildAlertCard('Alertes Résolues', '0', Colors.green), // Placeholder pour les alertes résolues
              ],
            ),
            const SizedBox(height: 20),

            // Bouton pour ajouter une alerte
            ElevatedButton(
              onPressed: _showAddAlertDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text('Ajouter une Alerte'),
            ),
            const SizedBox(height: 20),

            // Liste des alertes
            Expanded(
              child: ListView.builder(
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  return _buildAlertTile('Alerte ${index + 1}', _alerts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String count, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile(String title, String description) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }
}