import 'package:flutter/material.dart';
import '../models/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageCodeKey = 'languageCode';
  static const String _countryCodeKey = 'countryCode';

  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  Language get currentLanguage {
    return Language.languages.firstWhere(
      (language) =>
          language.languageCode == _currentLocale.languageCode &&
          language.countryCode == _currentLocale.countryCode,
      orElse: () => Language.languages.first,
    );
  }

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    final countryCode = prefs.getString(_countryCodeKey);

    if (languageCode != null && countryCode != null) {
      _currentLocale = Locale(languageCode, countryCode);
      notifyListeners();
    }
  }

  Future<void> setLanguage(Language language) async {
    if (_currentLocale.languageCode != language.languageCode ||
        _currentLocale.countryCode != language.countryCode) {
      _currentLocale = Locale(language.languageCode, language.countryCode);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, language.languageCode);
      await prefs.setString(_countryCodeKey, language.countryCode);

      notifyListeners();
    }
  }
} 