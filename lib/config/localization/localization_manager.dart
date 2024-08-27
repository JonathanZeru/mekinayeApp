import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/config_preference.dart';
import 'package:mekinaye/config/localization/translations/am.dart';
import 'package:mekinaye/config/localization/translations/en.dart';
import 'package:mekinaye/config/localization/translations/om.dart';
import 'package:mekinaye/config/localization/translations/ti.dart';

class LocalizationManager extends Translations {
  // prevent creating instance
  LocalizationManager._();

  static LocalizationManager? _instance;

  static LocalizationManager getInstance() {
    _instance ??= LocalizationManager._();
    return _instance!;
  }

  // default language
  static Locale defaultLanguage = supportedLanguages['en']!;

  // supported languages
  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en','US'),
    'am': const Locale('am'),
    'om': const Locale('en', 'AU'),
    'ti': const Locale('en', 'GB'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': englishLocalization,
        'am': amharicLocalization,
        'en_AU': oromifaLocalization,
        'en_GB': tigrinyanLocalization,
      };

  /// check if the language is supported
  static isLanguageSupported(String languageCode) =>
      supportedLanguages.keys.contains(languageCode);

  /// update app language by code language for example (en,ar..etc)
  static updateLanguage(String languageCode) async {
    // check if the language is supported
    if (!isLanguageSupported(languageCode)) return;
    // update current language in shared pref
    await ConfigPreference.setCurrentLanguage(languageCode);
    Get.updateLocale(supportedLanguages[languageCode]!);
    // print(supportedLanguages[languageCode]);
  }

  /// get current locale
  static Locale getCurrentLocal() => ConfigPreference.getCurrentLocal();
}
