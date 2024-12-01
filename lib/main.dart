import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:huduma/screens/homePage.dart';
import 'package:huduma/screens/infosPage.dart';
import 'package:huduma/screens/messageriePage.dart';
import 'package:huduma/screens/notificationsPage.dart';
import 'package:huduma/screens/signalerPage.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huduma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: [
            const Text("Huduma"),
            const Text("Messagerie"),
            const Text("Signaler"),
            const Text("Notifications"),
            const Text("Infos")
          ][_currentIndex],
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Ouvrir le drawer
            },
          ),
        ),
        body: [
          const HomePage(),
          const MessageriePage(),
          SignalerPage(),
          NotificationsPage(),
          const InfosPage()
        ][_currentIndex],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Paramètres'),
                onTap: () {
                  // Action pour Paramètres
                  Navigator.pop(context); // Fermer le drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Alertes'),
                onTap: () {
                  // Action pour Alertes
                  Navigator.pop(context); // Fermer le drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Mon Compte'),
                onTap: () {
                  // Action pour Mon Compte
                  Navigator.pop(context); // Fermer le drawer
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          selectedItemColor: Colors.green,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notif"),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "Infos")
          ],
        ),
      ),
    );
  }
}