
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannedCountriesProvider with ChangeNotifier {
  List<String> _bannedCountries = [];

  BannedCountriesProvider() {
    loadBannedCountries();
  }

  List<String> get bannedCountries => _bannedCountries;

  void addCountry(String country) {
    if (!_bannedCountries.contains(country)) {
      _bannedCountries.add(country);
      saveBannedCountries();
      notifyListeners();
    }
  }

  void removeCountry(String country) {
    _bannedCountries.remove(country);
    saveBannedCountries();
    notifyListeners();
  }

  Future<void> saveBannedCountries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bannedCountries', _bannedCountries);
  }

  Future<void> loadBannedCountries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _bannedCountries = prefs.getStringList('bannedCountries') ?? [];
    notifyListeners();
  }
}
