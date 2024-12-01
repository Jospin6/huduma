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
        final phoneNumber = option['num_tele']!;
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: phoneNumber,
        );

        try {
          // Vérifiez si l'URL peut être lancée
          if (await canLaunchUrl(launchUri)) {
            // Lancez l'appel
            await launchUrl(launchUri);
          } else {
            throw 'Impossible de lancer $launchUri';
          }

          // Récupérer les contacts de l'utilisateur
          final contacts = await _getContacts();

          // Récupérer la localisation de l'utilisateur
          Position position = await _getUserLocation();

          // Envoyer des SMS à chaque contact
          for (var contact in contacts) {
            await _sendSms(contact['phone'], position);
          }

          // Enregistrer l'alerte d'urgence dans Firestore
          await _saveEmergencyAlert(position);
        } catch (e) {
          // Gérer l'erreur
          print('Erreur: $e');
        }
      },
      child: const Text('Appeler'),
    );
  }

  Future<List<Map<String, dynamic>>> _getContacts() async {
    // Récupérer les contacts de Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('contacts')
        .where('userUID', isEqualTo: userUID)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<Position> _getUserLocation() async {
    // Demander la permission de localisation
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Permission de localisation refusée';
    }

    // Obtenir la position actuelle avec les nouveaux paramètres
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Distance en mètres pour les mises à jour
    );

    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }

  Future<void> _sendSms(String phone, Position position) async {
    String userName =
        'Nom Utilisateur'; // Remplacez par le nom de l'utilisateur
    String message =
        'Alerte, $userName vient de lancer une alerte ${option['title']} '
        'il se trouve à ${position.latitude}, ${position.longitude}. '
        'Veuillez l\'assister ou appeler les services d\'urgence appropriés pour son secours, merci.';

    try {
      // Envoi du SMS
      String result = await sendSMS(message: message, recipients: [phone])
          // ignore: body_might_complete_normally_catch_error
          .catchError((onError) {
        print(onError);
      });
      print('Résultat de l\'envoi: $result');
    } catch (e) {
      // Gérer les erreurs d'envoi de SMS
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
      'is_read': false,
    });
  }
}
