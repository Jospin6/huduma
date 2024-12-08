import 'package:flutter/material.dart';
import 'package:huduma/screens/alerteHistoryPage.dart';
import 'package:huduma/screens/contactsPage.dart';
import 'package:huduma/screens/homePage.dart';
import 'package:huduma/screens/infosPage.dart';
// import 'package:huduma/screens/messageriePage.dart';
import 'package:huduma/screens/notificationsPage.dart';
import 'package:huduma/screens/signalerPage.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: [
          const Text("Huduma"),
          const Text("Mes alertes"),
          const Text("Signaler"),
          const Text("Notifications"),
          const Text("Infos")
        ][_currentIndex],
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactsPage()),
                    )
                  },
              icon: const Icon(Icons.contact_emergency))
        ],
      ),
      body: [
        const HomePage(),
        const AlertHistoryPage(),
        const SignalerPage(),
        const NotificationsPage(),
        const InfosPage()
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setCurrentIndex(index),
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Mes alertes"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notif"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Infos")
        ],
      ),
    );
  }
}
