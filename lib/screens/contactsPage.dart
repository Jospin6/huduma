import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Contact> _contacts = [];

  void _addContact(String name, String phone) {
    setState(() {
      _contacts.add(Contact(name: name, phone: phone));
    });
    Navigator.of(context).pop(); 
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
          title: Text('Ajouter un Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                onChanged: (value) {
                  phone = value;
                },
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && phone.isNotEmpty) {
                  _addContact(name, phone);
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showAddContactDialog,
            child: Text('Ajouter Contact'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});
}