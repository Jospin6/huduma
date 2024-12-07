import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huduma/utils/user_preferences.dart';

class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String? userUID;

  @override
  void initState() {
    super.initState();
    _loadUserUID();
  }

  Future<void> _loadUserUID() async {
    userUID = await UserPreferences.getUserUID();
    setState(() {});
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addContact(String name, String phone) async {
    if (name.isNotEmpty && phone.isNotEmpty) {
      try {
        await _firestore.collection('contacts').add({
          'userUID': userUID,
          'name': name,
          'phone': phone,
        });
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du contact: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
    }
  }

  void _showAddContactDialog() {
    String name = '';
    String phone = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 5,
          title: const Text('Ajouter un Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                onChanged: (value) {
                  phone = value;
                },
                decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addContact(name, phone);
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
      appBar: AppBar(title: const Text('Contacts')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showAddContactDialog,
            child: const Text('Ajouter Contact'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('contacts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final contacts = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Contact(
                    name: data['name'],
                    phone: data['phone'],
                  );
                }).toList();

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          contact.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}