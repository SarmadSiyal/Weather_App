// ========== lib/settings_provider.dart ==========
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isCelsius = true;
  String? _lastCity;

  ThemeMode get themeMode => _themeMode;
  bool get isCelsius => _isCelsius;
  String? get lastCity => _lastCity;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    _isCelsius = prefs.getBool('isCelsius') ?? true;
    _lastCity = prefs.getString('lastCity');
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> toggleTemperatureUnit() async {
    _isCelsius = !_isCelsius;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCelsius', _isCelsius);
    notifyListeners();
  }

  Future<void> setLastCity(String city) async {
    _lastCity = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCity', city);
    notifyListeners();
  }
}
