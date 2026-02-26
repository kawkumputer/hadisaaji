import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hadith.dart';
import '../data/hadiths_data.dart';

class SupabaseService {
  static SupabaseClient get _client => Supabase.instance.client;

  static const String _cacheKey = 'cached_hadiths';
  static const String _cacheTimestampKey = 'cached_hadiths_timestamp';
  static const Duration _cacheDuration = Duration(hours: 6);

  /// Charge les hadiths : Supabase d'abord, puis cache, puis fallback local
  static Future<List<Hadith>> fetchHadiths() async {
    try {
      final hadiths = await _fetchFromSupabase();
      if (hadiths.isNotEmpty) {
        await _saveToCache(hadiths);
        return hadiths;
      }
    } catch (e) {
      // Supabase indisponible, on essaie le cache
    }

    // Essayer le cache local
    final cached = await _loadFromCache();
    if (cached.isNotEmpty) return cached;

    // Fallback : données locales hardcodées
    return List.from(allHadiths);
  }

  /// Charge les catégories depuis Supabase avec le count réel
  static Future<List<HadithCategory>> fetchCategories() async {
    try {
      final catResponse = await _client
          .from('categories')
          .select()
          .order('sort_order', ascending: true);

      final hadithResponse = await _client
          .from('hadiths')
          .select('category');

      // Compter les hadiths par catégorie
      final Map<String, int> counts = {};
      for (final row in hadithResponse) {
        final cat = row['category'] as String;
        counts[cat] = (counts[cat] ?? 0) + 1;
      }

      return (catResponse as List).map((json) {
        final name = json['name'] as String;
        return HadithCategory.fromJson(
          json as Map<String, dynamic>,
          counts[name] ?? 0,
        );
      }).toList();
    } catch (e) {
      return List.from(categories);
    }
  }

  /// Fetch depuis Supabase
  static Future<List<Hadith>> _fetchFromSupabase() async {
    final response = await _client
        .from('hadiths')
        .select()
        .order('id', ascending: true);

    return (response as List)
        .map((json) => Hadith.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Sauvegarder dans le cache local (SharedPreferences)
  static Future<void> _saveToCache(List<Hadith> hadiths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, Hadith.encodeList(hadiths));
    await prefs.setInt(
        _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Charger depuis le cache local
  static Future<List<Hadith>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_cacheKey);
    if (jsonStr == null) return [];

    // Cache disponible → on l'utilise
    if (jsonStr.isNotEmpty) {
      return Hadith.decodeList(jsonStr);
    }
    return [];
  }

  /// Vérifie si le cache est expiré (pour forcer un refresh en arrière-plan)
  static Future<bool> isCacheExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_cacheTimestampKey) ?? 0;
    if (timestamp == 0) return true;
    final cacheAge = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
    return cacheAge > _cacheDuration;
  }
}
