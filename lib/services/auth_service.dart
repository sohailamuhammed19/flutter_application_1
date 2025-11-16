import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _isLoggedInKey = 'isLoggedIn';

  // Simple in-memory storage for demo (in production, use secure storage)
  static final Map<String, String> _users = {
    'admin': 'admin123',
    'user': 'user123',
  };

  static Future<bool> login(String username, String password) async {
    // Check in-memory storage first
    if (_users.containsKey(username) && _users[username] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, username);
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }

    // Check saved credentials
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_usernameKey);
    final savedPassword = prefs.getString(_passwordKey);

    if (savedUsername == username && savedPassword == password) {
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }

    return false;
  }

  static Future<bool> signup(String username, String password) async {
    if (_users.containsKey(username)) {
      return false; // User already exists
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    await prefs.setBool(_isLoggedInKey, true);
    _users[username] = password;
    return true;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }
}

