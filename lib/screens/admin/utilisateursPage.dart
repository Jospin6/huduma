import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UtilisateursPage extends StatefulWidget {
  const UtilisateursPage({super.key});

  @override
  State<UtilisateursPage> createState() => _UtilisateursPageState();
}

class _UtilisateursPageState extends State<UtilisateursPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _users = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
      _filteredUsers = _users;
    });
  }

  void _filterUsers(String query) {
    final filtered = _users.where((user) {
      final name = user['name'].toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredUsers = filtered;
    });
  }

  void _showEditDialog(String userId) {
    // Liste des urgences
    final List<String> urgences = [
      'Insécurité',
      'Accident de la route',
      'Urgence médicale',
      'Incendies',
      'Catastrophe naturelle',
    ];

    // Variable pour stocker l'urgence sélectionnée
    String? selectedUrgence;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier l\'urgence'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Veuillez choisir une urgence :'),
              DropdownButton<String>(
                value: selectedUrgence,
                hint: const Text('Sélectionner une urgence'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUrgence = newValue;
                  });
                },
                items: urgences.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (selectedUrgence != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'urgence': selectedUrgence});
                  Navigator.of(context).pop();
                  _fetchUsers(); // Recharger les utilisateurs
                } else {
                  // Afficher un message d'erreur si aucune urgence n'est sélectionnée
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Veuillez sélectionner une urgence')),
                  );
                }
              },
              child: const Text('Valider'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
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
        title: const Text('Utilisateurs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          String initials = user['name'][0].toUpperCase();

          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                shape: BoxShape.circle,
              ),
              child: Text(
                initials,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('${user['name']} ${user['lastName']}'),
            subtitle: Text('Urgence: ${user['urgence']}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(user['id']),
            ),
          );
        },
      ),
    );
  }
}
