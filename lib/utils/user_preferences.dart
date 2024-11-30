import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userUIDKey = 'userUID';

  // Enregistrer l'UID
  static Future<void> saveUserUID(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userUIDKey, uid);
  }

  // Récupérer l'UID
  static Future<String?> getUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUIDKey);
  }

  // Vérifier si l'utilisateur est enregistré
  static Future<bool> isUserRegistered() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUserRegistered') ?? false;
  }
}