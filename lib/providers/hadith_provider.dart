import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hadiths_data.dart';
import '../models/hadith.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';

class HadithProvider extends ChangeNotifier {
  List<Hadith> _hadiths = [];
  List<HadithCategory> _categories = [];
  List<int> _favoriteIds = [];
  double _arabicFontSize = 22.0;
  double _pulaarFontSize = 16.0;
  bool _isDarkMode = false;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _notificationsEnabled = true;
  int _notifHour = 7;
  int _notifMinute = 0;

  List<Hadith> get hadiths => _hadiths;
  List<HadithCategory> get dynamicCategories => _categories;
  List<int> get favoriteIds => _favoriteIds;
  double get arabicFontSize => _arabicFontSize;
  double get pulaarFontSize => _pulaarFontSize;
  bool get isDarkMode => _isDarkMode;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _notificationsEnabled;
  int get notifHour => _notifHour;
  int get notifMinute => _notifMinute;
  TimeOfDay get notifTime => TimeOfDay(hour: _notifHour, minute: _notifMinute);

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
    final now = DateTime.now();
    final seed = now.year * 1000 + now.difference(DateTime(now.year, 1, 1)).inDays;
    final random = Random(seed);
    return _hadiths[random.nextInt(_hadiths.length)];
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
    try {
      await _loadPreferences();
    } catch (e) {
      debugPrint('[HadithProvider] loadPreferences error: $e');
    }
    notifyListeners();

    // Puis charger depuis Supabase en arrière-plan (non-bloquant)
    refreshFromSupabase().catchError((e) {
      debugPrint('[HadithProvider] refreshFromSupabase error: $e');
    });
  }

  Future<void> refreshFromSupabase() async {
    try {
      final remoteHadiths = await SupabaseService.fetchHadiths()
          .timeout(const Duration(seconds: 10));
      if (remoteHadiths.isNotEmpty) {
        _hadiths = remoteHadiths;
      }
      final remoteCats = await SupabaseService.fetchCategories()
          .timeout(const Duration(seconds: 10));
      if (remoteCats.isNotEmpty) {
        _categories = remoteCats;
      }
    } catch (e) {
      debugPrint('[HadithProvider] Supabase fetch error: $e');
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
    _notificationsEnabled = await NotificationService.isEnabled;
    _notifHour = await NotificationService.notifHour;
    _notifMinute = await NotificationService.notifMinute;
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

  Hadith? getHadithById(int id) {
    try {
      return _hadiths.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

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

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await NotificationService.setEnabled(enabled);
    if (enabled) {
      await _scheduleNotification();
    } else {
      await NotificationService.cancelDailyHadith();
    }
    notifyListeners();
  }

  Future<void> setNotifTime(TimeOfDay time) async {
    _notifHour = time.hour;
    _notifMinute = time.minute;
    await NotificationService.setTime(time.hour, time.minute);
    if (_notificationsEnabled) {
      await _scheduleNotification();
    }
    notifyListeners();
  }

  Future<void> _scheduleNotification() async {
    final hadith = hadithOfTheDay;
    await NotificationService.scheduleDailyHadith(
      title: '📖 Hadiis Ñalngu Hannde',
      body: '${hadith.chapterTitle}\n${hadith.pulaarTranslation.substring(0, hadith.pulaarTranslation.length.clamp(0, 100))}...',
      hour: _notifHour,
      minute: _notifMinute,
      hadithId: hadith.id,
    );
  }

  Future<void> initNotifications() async {
    await NotificationService.requestPermissions();
    if (_notificationsEnabled) {
      await _scheduleNotification();
    }
  }
}
