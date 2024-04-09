import 'package:shared_preferences/shared_preferences.dart';

class Memory {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setToken(String token) {
    prefs!.setString('token', token);
  }

  static String? getToken() {
    return prefs!.getString('token');
  }

  //set role
  static setRole(String role) {
    prefs!.setString('role', role);
  }

  static String? getRole() {
    return prefs!.getString('role');
  }

  static Future<void> clear() async {
    await prefs!.clear();
  }
}
