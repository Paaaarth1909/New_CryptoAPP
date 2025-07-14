class Language {
  final String name;
  final String country;
  final String languageCode;
  final String countryCode;

  const Language({
    required this.name,
    required this.country,
    required this.languageCode,
    required this.countryCode,
  });

  static const List<Language> languages = [
    Language(
      name: 'English',
      country: 'United States',
      languageCode: 'en',
      countryCode: 'US',
    ),
    Language(
      name: 'Español',
      country: 'España',
      languageCode: 'es',
      countryCode: 'ES',
    ),
    Language(
      name: 'Français',
      country: 'France',
      languageCode: 'fr',
      countryCode: 'FR',
    ),
    Language(
      name: 'Deutsch',
      country: 'Germany',
      languageCode: 'de',
      countryCode: 'DE',
    ),
    Language(
      name: 'Italiano',
      country: 'Italy',
      languageCode: 'it',
      countryCode: 'IT',
    ),
    Language(
      name: 'Português',
      country: 'Brasil',
      languageCode: 'pt',
      countryCode: 'BR',
    ),
  ];
} 