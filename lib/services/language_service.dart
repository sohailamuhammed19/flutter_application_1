import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'language';
  static String _currentLanguage = 'en';

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'en';
    return _currentLanguage;
  }

  static Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static String getCurrentLanguage() => _currentLanguage;

  static Map<String, String> translations = {
    'en': 'English',
    'ar': 'العربية',
  };
}

