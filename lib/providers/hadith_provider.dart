import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hadiths_data.dart';
import '../models/hadith.dart';
import '../services/supabase_service.dart';

class HadithProvider extends ChangeNotifier {
  List<Hadith> _hadiths = [];
  List<HadithCategory> _categories = [];
  List<int> _favoriteIds = [];
  double _arabicFontSize = 22.0;
  double _pulaarFontSize = 16.0;
  bool _isDarkMode = false;
  String _searchQuery = '';
  bool _isLoading = false;

  List<Hadith> get hadiths => _hadiths;
  List<HadithCategory> get dynamicCategories => _categories;
  List<int> get favoriteIds => _favoriteIds;
  double get arabicFontSize => _arabicFontSize;
  double get pulaarFontSize => _pulaarFontSize;
  bool get isDarkMode => _isDarkMode;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<Hadith> get favoriteHadiths =>
      _hadiths.where((h) => _favoriteIds.contains(h.id)).toList();

  List<Hadith> get filteredHadiths {
    if (_searchQuery.isEmpty) return _hadiths;
    final q = _searchQuery.toLowerCase();
    return _hadiths.where((h) {
      return h.chapterTitle.toLowerCase().contains(q) ||
          h.pulaarTranslation.toLowerCase().contains(q) ||
          h.arabicText.contains(q) ||
          h.category.toLowerCase().contains(q);
    }).toList();
  }

  List<Hadith> getHadithsByCategory(String category) {
    return _hadiths.where((h) => h.category == category).toList();
  }

  Hadith get hadithOfTheDay {
    if (_hadiths.isEmpty) return allHadiths.first;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _hadiths[dayOfYear % _hadiths.length];
  }

  Hadith get randomHadith {
    if (_hadiths.isEmpty) return allHadiths.first;
    return _hadiths[Random().nextInt(_hadiths.length)];
  }

  Future<void> init() async {
    _isLoading = true;
    // Charger les données locales d'abord (affichage instantané)
    _hadiths = List.from(allHadiths);
    _categories = List.from(categories);
    await _loadPreferences();
    notifyListeners();

    // Puis charger depuis Supabase en arrière-plan
    await refreshFromSupabase();
  }

  Future<void> refreshFromSupabase() async {
    try {
      final remoteHadiths = await SupabaseService.fetchHadiths();
      if (remoteHadiths.isNotEmpty) {
        _hadiths = remoteHadiths;
      }
      final remoteCats = await SupabaseService.fetchCategories();
      if (remoteCats.isNotEmpty) {
        _categories = remoteCats;
      }
    } catch (e) {
      // Silencieux — on garde les données locales/cache
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = (prefs.getStringList('favorites') ?? [])
        .map((e) => int.parse(e))
        .toList();
    _arabicFontSize = prefs.getDouble('arabicFontSize') ?? 22.0;
    _pulaarFontSize = prefs.getDouble('pulaarFontSize') ?? 16.0;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleFavorite(int hadithId) async {
    if (_favoriteIds.contains(hadithId)) {
      _favoriteIds.remove(hadithId);
    } else {
      _favoriteIds.add(hadithId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favorites', _favoriteIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  bool isFavorite(int hadithId) => _favoriteIds.contains(hadithId);

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', size);
    notifyListeners();
  }

  Future<void> setPulaarFontSize(double size) async {
    _pulaarFontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('pulaarFontSize', size);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
