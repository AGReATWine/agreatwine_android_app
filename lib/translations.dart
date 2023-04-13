import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

// Add the Translations class to handle the translations
class Translations {
  final Locale locale;

  Translations(this.locale);

  static Translations of(BuildContext context) {
  return Localizations.of<Translations>(context, Translations)!;
}

  String get appTitle {
    return Intl.message('AGReaTWine', name: 'appTitle');
  }

  String get home {
    return Intl.message('Home', name: 'home');
  }

  String get list {
    return Intl.message('Appellations', name: 'appellations');
  }

  String get search {
    return Intl.message('Search', name: 'search');
  }
}

// Add a TranslationsDelegate class to handle the translations delegate
class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    final String? jsonContent =
        await rootBundle.loadString('assets/locale/${locale.languageCode}.json');
    final jsonMap = json.decode(jsonContent!);
    return Translations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) {
    return false;
  }
}