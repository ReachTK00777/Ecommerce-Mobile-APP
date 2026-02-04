import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static bool isLoggedIn = false;

  static Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    isLoggedIn = true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    isLoggedIn = false;
  }

  static Future<void> restoreLogin() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getString('token') != null;
  }
}
