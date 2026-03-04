import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/artisan_model.dart';

abstract class ArtisanLocalDataSource {
  Future<void> cacheArtisans(List<ArtisanModel> artisans);
  Future<List<ArtisanModel>> getCachedArtisans();
  Future<bool> hasCachedArtisans();
  Future<void> saveTradePref(String trade);
  Future<String?> getSavedTradePref();
}

class ArtisanLocalDataSourceImpl implements ArtisanLocalDataSource {
  final SharedPreferences prefs;

  // Keys
  static const _cachedArtisansKey = 'cached_artisans';
  static const _tradePrefKey = 'user_trade_pref';
  static const _cacheTimestampKey = 'artisans_cache_timestamp';

  // Cache is valid for 10 minutes
  static const _cacheDurationMinutes = 10;

  ArtisanLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheArtisans(List<ArtisanModel> artisans) async {
    final jsonList = artisans.map((a) => a.toJson()).toList();
    await prefs.setString(_cachedArtisansKey, json.encode(jsonList));
    await prefs.setInt(
      _cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<List<ArtisanModel>> getCachedArtisans() async {
    final jsonString = prefs.getString(_cachedArtisansKey);
    if (jsonString == null) return [];

    final jsonList = json.decode(jsonString) as List;
    return jsonList
        .map((e) => ArtisanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> hasCachedArtisans() async {
    final timestamp = prefs.getInt(_cacheTimestampKey);
    if (timestamp == null) return false;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final isExpired =
        DateTime.now().difference(cachedAt).inMinutes > _cacheDurationMinutes;

    return !isExpired && prefs.containsKey(_cachedArtisansKey);
  }

  @override
  Future<void> saveTradePref(String trade) async {
    await prefs.setString(_tradePrefKey, trade);
  }

  @override
  Future<String?> getSavedTradePref() async {
    return prefs.getString(_tradePrefKey);
  }
}
