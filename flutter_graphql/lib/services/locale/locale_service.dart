import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';

class LocaleService {
  final _box = GetStorage();
  final _key = 'languageCode';

  /// Get info from local storage and return ThemeMode
  Locale get locale => Locale(_loadLocaleFromBox());
  String get languageCode => _loadLocaleFromBox();

  /// Load  from local storage and if it's empty, returns default
  String _loadLocaleFromBox() => _box.read(_key) ?? 'en';

  /// Save to local storage
  void _saveLocaleToBox(String languageCode) => _box.write(_key, languageCode);

  /// Change and save to local storage
  void changeLocale(String languageCode) {
    Get.updateLocale(Locale(languageCode));
    _saveLocaleToBox(languageCode);
  }
}

LocaleService localeService = LocaleService();
