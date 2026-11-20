import 'package:shared_preferences/shared_preferences.dart';
import '../models/account.dart';

class LoginController {
  // Autentikasi user dan simpan sesi ke SharedPreferences
  Future<bool> login(String username, String password) async {
    if (username.trim() == account.username &&
        password.trim() == account.password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('username', username.trim());
      return true;
    }
    return false;
  }

  // Cek apakah ada sesi login aktif
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Mengambil username yang sedang login
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? account.username;
  }

  // Logout dan hapus sesi SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
