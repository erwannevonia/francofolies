import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavorisProvider extends ChangeNotifier {
  Set<int> _favoris = {};
  final String _storageKey = 'favoris';

  Set<int> get favoris => _favoris;

  FavorisProvider() {
    _loadFavoris();
  }

  void _loadFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey);
    if (saved != null) {
      _favoris = saved.map((id) => int.parse(id)).toSet();
      notifyListeners();
    }
  }

  void toggleFavori(int userId, int concertId) async {
    if (_favoris.contains(concertId)) {
      _favoris.remove(concertId);
      // Appelle API pour supprimer
      // ApiService.removeFavori(userId, concertId);
    } else {
      _favoris.add(concertId);
      // Appelle API pour ajouter
      // ApiService.addFavori(userId, concertId);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        _storageKey, _favoris.map((e) => e.toString()).toList());

    notifyListeners();
  }

  bool isFavori(int concertId) => _favoris.contains(concertId);
}
