import 'package:flutter/material.dart';
import 'package:huduma/screens/chatPage.dart';
import 'package:huduma/utils/emergency_options.dart';

class MessageriePage extends StatefulWidget {
  const MessageriePage({super.key});

  @override
  State<MessageriePage> createState() => _MessageriePageState();
}

class _MessageriePageState extends State<MessageriePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options d\'Urgence', style: TextStyle(color: Colors.white),),
      ),
      body: emergencyOptions.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Indicateur de chargement si la liste est vide
          : ListView.builder(
              itemCount: emergencyOptions.length,
              itemBuilder: (context, index) {
                final option = emergencyOptions[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: option['image'] != null
                        ? AssetImage(option['image']!)
                        : null, // Gestion de l'image
                    backgroundColor: Colors.grey, // Couleur de fond par défaut
                  ),
                  title: Text(option['title'] ?? 'Titre inconnu', style: const TextStyle(color: Colors.white),),
                  subtitle: Text(option['num_tele'] ?? 'Numéro inconnu', style: const TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(option: option),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}