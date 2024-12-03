import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userUIDKey = 'userUID';
  static const String isUserRegisteredKey = 'isUserRegistered';

  // Enregistrer l'UID de l'utilisateur
  static Future<void> saveUserUID(String uid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(userUIDKey, uid);
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'UID: $e');
    }
  }

  // Récupérer l'UID de l'utilisateur
  static Future<String?> getUserUID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userUIDKey);
    } catch (e) {
      print('Erreur lors de la récupération de l\'UID: $e');
      return null;
    }
  }

  // Vérifier si l'utilisateur est enregistré
  static Future<bool> isUserRegistered() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(isUserRegisteredKey) ?? false;
    } catch (e) {
      print(
          'Erreur lors de la vérification de l\'enregistrement de l\'utilisateur: $e');
      return false;
    }
  }

  // Enregistrer l'état de l'utilisateur (enregistré ou non)
  static Future<void> setUserRegistered(bool isRegistered) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isUserRegisteredKey, isRegistered);
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'état de l\'utilisateur: $e');
    }
  }
}
