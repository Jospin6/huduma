import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';

class AlerteAppelWidget extends StatelessWidget {
  final String userUID;
  final Map<String, dynamic> option;

  AlerteAppelWidget({required this.userUID, required this.option});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final phoneNumber = option['num_tele'] ?? '';
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: phoneNumber,
        );

        try {
          if (await canLaunchUrl(launchUri)) {
            await launchUrl(launchUri);
          } else {
            throw 'Impossible de lancer $launchUri';
          }

          final contacts = await _getContacts();
          Position position = await _getUserLocation();

          for (var contact in contacts) {
            await _sendSms(contact['phone'], position);
          }

          await _saveEmergencyAlert(position);

          await FirebaseFirestore.instance.collection('notifications').add({
            'titre': option['title'],
            'contenu': 'y a une alerte ${option['title']} dans votre région',
            'timestamp': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          print('Erreur: $e');
        }
      },
      child: const Text('Appeler'),
    );
  }

  Future<List<Map<String, dynamic>>> _getContacts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('contacts')
        .where('userUID', isEqualTo: userUID)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<Position> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Permission de localisation refusée';
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }

  Future<void> _sendSms(String phone, Position position) async {
    String userName = 'Nom Utilisateur'; // Remplacez par le nom de l'utilisateur
    String message =
        'Alerte, $userName vient de lancer une alerte ${option['title']} '
        'il se trouve à ${position.latitude}, ${position.longitude}. '
        'Veuillez l\'assister ou appeler les services d\'urgence appropriés pour son secours, merci.';

    try {
      String result = await sendSMS(message: message, recipients: [phone])
          .catchError((onError) {
        print(onError);
      });
      print('Résultat de l\'envoi: $result');
    } catch (e) {
      print('Erreur lors de l\'envoi du SMS à $phone: $e');
    }
  }

  Future<void> _saveEmergencyAlert(Position position) async {
    await FirebaseFirestore.instance.collection('alerte_urgence').add({
      'userUID': userUID,
      'title': option['title'],
      'date': DateTime.now(),
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    });
  }
}