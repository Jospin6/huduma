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
        title: const Text('Options d\'Urgence'),
      ),
      body: ListView.builder(
        itemCount: emergencyOptions.length,
        itemBuilder: (context, index) {
          final option = emergencyOptions[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25, 
              backgroundImage: AssetImage(option['image']!), 
            ),
            title: Text(option['title']!),
            subtitle: Text(option['num_tele']!),
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