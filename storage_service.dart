import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Initialize storage
  static Future<StorageService> init() async {
    final instance = StorageService();
    await instance._init();
    return instance;
  }

  Future<void> _init() async {
    // SharedPreferences is initialized lazily, just verify it works
    await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _sharedPreferences async {
    return await SharedPreferences.getInstance();
  }

  // ============ String Methods ============
  
  Future<void> saveString(String key, String value) async {
    final prefs = await _sharedPreferences;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.getString(key);
  }

  // ============ Int Methods ============
  
  Future<void> saveInt(String key, int value) async {
    final prefs = await _sharedPreferences;
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.getInt(key);
  }

  Future<int> getIntOrDefault(String key, int defaultValue) async {
    final prefs = await _sharedPreferences;
    return prefs.getInt(key) ?? defaultValue;
  }

  // ============ Bool Methods ============
  
  Future<void> saveBool(String key, bool value) async {
    final prefs = await _sharedPreferences;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.getBool(key);
  }

  Future<bool> getBoolOrDefault(String key, bool defaultValue) async {
    final prefs = await _sharedPreferences;
    return prefs.getBool(key) ?? defaultValue;
  }

  // ============ Double Methods ============
  
  Future<void> saveDouble(String key, double value) async {
    final prefs = await _sharedPreferences;
    await prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.getDouble(key);
  }

  Future<double> getDoubleOrDefault(String key, double defaultValue) async {
    final prefs = await _sharedPreferences;
    return prefs.getDouble(key) ?? defaultValue;
  }

  // ============ String List Methods ============
  
  Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await _sharedPreferences;
    await prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.getStringList(key);
  }

  Future<List<String>> getStringListOrDefault(String key, List<String> defaultValue) async {
    final prefs = await _sharedPreferences;
    return prefs.getStringList(key) ?? defaultValue;
  }

  // ============ JSON Methods ============
  
  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    final prefs = await _sharedPreferences;
    await prefs.setString(key, json.encode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await _sharedPreferences;
    final String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  Future<Map<String, dynamic>> getJsonOrDefault(
    String key, 
    Map<String, dynamic> defaultValue
  ) async {
    final result = await getJson(key);
    return result ?? defaultValue;
  }

  // ============ Object Methods (with fromJson/toJson) ============
  
  Future<void> saveObject<T>(String key, T object, Map<String, dynamic> Function(T) toJson) async {
    await saveJson(key, toJson(object));
  }

  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final json = await getJson(key);
    if (json != null) {
      return fromJson(json);
    }
    return null;
  }

  // ============ Secure Storage Methods (for sensitive data) ============
  
  Future<void> saveSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> saveSecureToken(String token) async {
    await saveSecureString('auth_token', token);
  }

  Future<String?> getSecureToken() async {
    return await getSecureString('auth_token');
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // ============ Game Data Methods ============
  
  Future<void> saveGameProgress({
    required int totalScore,
    required int currentLevel,
    required int collectedKeys,
    required List<int> completedLevels,
    required Map<String, int> subjectScores,
    required int dailyStreak,
  }) async {
    final prefs = await _sharedPreferences;
    await prefs.setInt(AppConstants.keyTotalScore, totalScore);
    await prefs.setInt(AppConstants.keyCurrentLevel, currentLevel);
    await prefs.setInt(AppConstants.keyCollectedKeys, collectedKeys);
    await prefs.setStringList(
      AppConstants.keyCompletedLevels,
      completedLevels.map((e) => e.toString()).toList(),
    );
    await prefs.setString(
      AppConstants.keySubjectScores,
      json.encode(subjectScores),
    );
    await prefs.setInt(AppConstants.keyDailyStreak, dailyStreak);
    await prefs.setString(AppConstants.keyLastPlayed, DateTime.now().toIso8601String());
  }

  Future<Map<String, dynamic>> getGameProgress() async {
    final prefs = await _sharedPreferences;
    final completedLevelsJson = prefs.getStringList(AppConstants.keyCompletedLevels);
    final subjectScoresJson = prefs.getString(AppConstants.keySubjectScores);
    
    return {
      'totalScore': prefs.getInt(AppConstants.keyTotalScore) ?? 0,
      'currentLevel': prefs.getInt(AppConstants.keyCurrentLevel) ?? 1,
      'collectedKeys': prefs.getInt(AppConstants.keyCollectedKeys) ?? 0,
      'completedLevels': completedLevelsJson?.map(int.parse).toList() ?? [],
      'subjectScores': subjectScoresJson != null 
          ? json.decode(subjectScoresJson) 
          : {'Math': 0, 'English': 0, 'Science': 0},
      'dailyStreak': prefs.getInt(AppConstants.keyDailyStreak) ?? 0,
      'lastPlayed': prefs.getString(AppConstants.keyLastPlayed),
    };
  }

  // ============ User Data Methods ============
  
  Future<void> saveUserData({
    required String userName,
    required String userEmail,
    required int userAge,
    required int selectedAvatar,
    required String avatarName,
  }) async {
    final prefs = await _sharedPreferences;
    await prefs.setString(AppConstants.keyUserName, userName);
    await prefs.setString(AppConstants.keyUserEmail, userEmail);
    await prefs.setInt(AppConstants.keyUserAge, userAge);
    await prefs.setInt(AppConstants.keySelectedAvatar, selectedAvatar);
    await prefs.setString(AppConstants.keyAvatarName, avatarName);
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await _sharedPreferences;
    return {
      'userName': prefs.getString(AppConstants.keyUserName) ?? '',
      'userEmail': prefs.getString(AppConstants.keyUserEmail) ?? '',
      'userAge': prefs.getInt(AppConstants.keyUserAge) ?? 0,
      'selectedAvatar': prefs.getInt(AppConstants.keySelectedAvatar) ?? 0,
      'avatarName': prefs.getString(AppConstants.keyAvatarName) ?? 'Explorer',
    };
  }

  // ============ Settings Methods ============
  
  Future<void> saveSettings({
    required bool soundEnabled,
    required bool musicEnabled,
    required bool vibrationEnabled,
    required String language,
  }) async {
    final prefs = await _sharedPreferences;
    await prefs.setBool(AppConstants.keySoundEnabled, soundEnabled);
    await prefs.setBool(AppConstants.keyMusicEnabled, musicEnabled);
    await prefs.setBool(AppConstants.keyVibrationEnabled, vibrationEnabled);
    await prefs.setString(AppConstants.keyLanguage, language);
  }

  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await _sharedPreferences;
    return {
      'soundEnabled': prefs.getBool(AppConstants.keySoundEnabled) ?? true,
      'musicEnabled': prefs.getBool(AppConstants.keyMusicEnabled) ?? true,
      'vibrationEnabled': prefs.getBool(AppConstants.keyVibrationEnabled) ?? true,
      'language': prefs.getString(AppConstants.keyLanguage) ?? 'en',
    };
  }

  // ============ Cache Management ============
  
  Future<void> clearCache() async {
    final prefs = await _sharedPreferences;
    final keysToKeep = [
      AppConstants.keyIsLoggedIn,
      AppConstants.keyUserEmail,
      AppConstants.keyUserName,
      AppConstants.keyUserAge,
      AppConstants.keyUserAvatar,
      AppConstants.keyTotalScore,
      AppConstants.keyCurrentLevel,
      AppConstants.keyCollectedKeys,
      AppConstants.keyCompletedLevels,
      AppConstants.keyDailyStreak,
      AppConstants.keyLastPlayed,
      AppConstants.keySubjectScores,
    ];
    
    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (!keysToKeep.contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  Future<void> clearAllData() async {
    final prefs = await _sharedPreferences;
    await prefs.clear();
    await clearSecureStorage();
  }

  // ============ Helper Methods ============
  
  Future<bool> containsKey(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.containsKey(key);
  }

  Future<void> removeKey(String key) async {
    final prefs = await _sharedPreferences;
    await prefs.remove(key);
  }

  Future<Set<String>> getAllKeys() async {
    final prefs = await _sharedPreferences;
    return prefs.getKeys();
  }

  // ============ Batch Operations ============
  
  Future<void> saveMultiple(Map<String, dynamic> data) async {
    final prefs = await _sharedPreferences;
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      }
    }
  }

  Future<Map<String, dynamic>> getMultiple(List<String> keys) async {
    final prefs = await _sharedPreferences;
    final result = <String, dynamic>{};
    
    for (final key in keys) {
      if (prefs.containsKey(key)) {
        // Try to determine type
        final value = prefs.get(key);
        if (value != null) {
          result[key] = value;
        }
      }
    }
    
    return result;
  }
}

// Storage keys constants
class StorageKeys {
  // User related
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userAge = 'user_age';
  static const String userAvatar = 'user_avatar';
  static const String isLoggedIn = 'is_logged_in';
  
  // Game progress
  static const String totalScore = 'total_score';
  static const String currentLevel = 'current_level';
  static const String collectedKeys = 'collected_keys';
  static const String completedLevels = 'completed_levels';
  static const String subjectScores = 'subject_scores';
  static const String dailyStreak = 'daily_streak';
  static const String lastPlayed = 'last_played';
  
  // Avatar
  static const String selectedAvatar = 'selected_avatar';
  static const String avatarName = 'avatar_name';
  static const String unlockedAvatars = 'unlocked_avatars';
  
  // Settings
  static const String soundEnabled = 'sound_enabled';
  static const String musicEnabled = 'music_enabled';
  static const String vibrationEnabled = 'vibration_enabled';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  
  // Achievements
  static const String earnedAchievements = 'earned_achievements';
  static const String achievementProgress = 'achievement_progress';
  
  // Cache
  static const String lastSyncTime = 'last_sync_time';
  static const String cacheVersion = 'cache_version';
}

// Storage service provider (extends ChangeNotifier for UI updates)
class StorageProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  
  Future<void> saveGameProgress(Map<String, dynamic> progress) async {
    await _storage.saveGameProgress(
      totalScore: progress['totalScore'],
      currentLevel: progress['currentLevel'],
      collectedKeys: progress['collectedKeys'],
      completedLevels: progress['completedLevels'],
      subjectScores: progress['subjectScores'],
      dailyStreak: progress['dailyStreak'],
    );
    notifyListeners();
  }
  
  Future<Map<String, dynamic>> getGameProgress() async {
    return await _storage.getGameProgress();
  }
  
  Future<void> clearAllData() async {
    await _storage.clearAllData();
    notifyListeners();
  }
}