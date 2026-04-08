import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treasure_minds/config/theme.dart';
import '../config/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  // Audio settings
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 0.8;
  double _musicVolume = 0.6;
  
  // Notification settings
  bool _vibrationEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _dailyReminderEnabled = true;
  bool _achievementAlertsEnabled = true;
  String _dailyReminderTime = "09:00";
  
  // Display settings
  bool _darkModeEnabled = false;
  bool _animationsEnabled = true;
  double _textScaleFactor = 1.0;
  String _themeColor = "blue";
  
  // Privacy settings
  bool _analyticsEnabled = true;
  bool _personalizedAdsEnabled = false;
  bool _dataSharingEnabled = true;
  
  // Gameplay settings
  bool _autoHintEnabled = false;
  bool _confettiEnabled = true;
  int _defaultDifficulty = 1; // 0: Easy, 1: Medium, 2: Hard
  
  // Cache settings
  int _cacheSize = 0;
  bool _isLoading = false;
  
  // Available theme colors
  final List<ThemeColorOption> _themeColors = [
    ThemeColorOption(name: 'Blue', color: AppColors.neonBlue, value: 'blue'),
    ThemeColorOption(name: 'Purple', color: AppColors.neonPurple, value: 'purple'),
    ThemeColorOption(name: 'Green', color: AppColors.neonGreen, value: 'green'),
    ThemeColorOption(name: 'Orange', color: AppColors.neonOrange, value: 'orange'),
    ThemeColorOption(name: 'Pink', color: AppColors.neonPink, value: 'pink'),
    ThemeColorOption(name: 'Rainbow', color: AppColors.gold, value: 'rainbow'),
  ];
  
  // Getter methods
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get soundVolume => _soundVolume;
  double get musicVolume => _musicVolume;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get dailyReminderEnabled => _dailyReminderEnabled;
  bool get achievementAlertsEnabled => _achievementAlertsEnabled;
  String get dailyReminderTime => _dailyReminderTime;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get animationsEnabled => _animationsEnabled;
  double get textScaleFactor => _textScaleFactor;
  String get themeColor => _themeColor;
  bool get analyticsEnabled => _analyticsEnabled;
  bool get personalizedAdsEnabled => _personalizedAdsEnabled;
  bool get dataSharingEnabled => _dataSharingEnabled;
  bool get autoHintEnabled => _autoHintEnabled;
  bool get confettiEnabled => _confettiEnabled;
  int get defaultDifficulty => _defaultDifficulty;
  int get cacheSize => _cacheSize;
  bool get isLoading => _isLoading;
  List<ThemeColorOption> get themeColors => _themeColors;
  
  // Computed properties
  String get difficultyLabel {
    switch (_defaultDifficulty) {
      case 0: return 'Easy';
      case 1: return 'Medium';
      case 2: return 'Hard';
      default: return 'Medium';
    }
  }
  
  Color get primaryThemeColor {
    final theme = _themeColors.firstWhere(
      (t) => t.value == _themeColor,
      orElse: () => _themeColors[0],
    );
    return theme.color;
  }
  
  // Constructor
  SettingsProvider() {
    _loadSettings();
  }
  
  // Load all settings from SharedPreferences
  Future<void> _loadSettings() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Audio settings
      _soundEnabled = prefs.getBool(AppConstants.keySoundEnabled) ?? true;
      _musicEnabled = prefs.getBool(AppConstants.keyMusicEnabled) ?? true;
      _soundVolume = prefs.getDouble('sound_volume') ?? 0.8;
      _musicVolume = prefs.getDouble('music_volume') ?? 0.6;
      
      // Notification settings
      _vibrationEnabled = prefs.getBool(AppConstants.keyVibrationEnabled) ?? true;
      _pushNotificationsEnabled = prefs.getBool('push_notifications') ?? true;
      _dailyReminderEnabled = prefs.getBool('daily_reminder') ?? true;
      _achievementAlertsEnabled = prefs.getBool('achievement_alerts') ?? true;
      _dailyReminderTime = prefs.getString('daily_reminder_time') ?? "09:00";
      
      // Display settings
      _darkModeEnabled = prefs.getBool('dark_mode') ?? false;
      _animationsEnabled = prefs.getBool('animations_enabled') ?? true;
      _textScaleFactor = prefs.getDouble('text_scale_factor') ?? 1.0;
      _themeColor = prefs.getString('theme_color') ?? 'blue';
      
      // Privacy settings
      _analyticsEnabled = prefs.getBool('analytics_enabled') ?? true;
      _personalizedAdsEnabled = prefs.getBool('personalized_ads') ?? false;
      _dataSharingEnabled = prefs.getBool('data_sharing') ?? true;
      
      // Gameplay settings
      _autoHintEnabled = prefs.getBool('auto_hint') ?? false;
      _confettiEnabled = prefs.getBool('confetti_enabled') ?? true;
      _defaultDifficulty = prefs.getInt('default_difficulty') ?? 1;
      
      // Cache info
      _cacheSize = prefs.getInt('cache_size') ?? 0;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ============ Audio Settings ============
  
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keySoundEnabled, enabled);
    notifyListeners();
  }
  
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyMusicEnabled, enabled);
    notifyListeners();
  }
  
  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sound_volume', volume);
    notifyListeners();
  }
  
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('music_volume', volume);
    notifyListeners();
  }
  
  // ============ Notification Settings ============
  
  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyVibrationEnabled, enabled);
    notifyListeners();
  }
  
  Future<void> setPushNotificationsEnabled(bool enabled) async {
    _pushNotificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', enabled);
    notifyListeners();
  }
  
  Future<void> setDailyReminderEnabled(bool enabled) async {
    _dailyReminderEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', enabled);
    notifyListeners();
  }
  
  Future<void> setAchievementAlertsEnabled(bool enabled) async {
    _achievementAlertsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('achievement_alerts', enabled);
    notifyListeners();
  }
  
  Future<void> setDailyReminderTime(String time) async {
    _dailyReminderTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('daily_reminder_time', time);
    notifyListeners();
  }
  
  // ============ Display Settings ============
  
  Future<void> setDarkModeEnabled(bool enabled) async {
    _darkModeEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', enabled);
    notifyListeners();
  }
  
  Future<void> setAnimationsEnabled(bool enabled) async {
    _animationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animations_enabled', enabled);
    notifyListeners();
  }
  
  Future<void> setTextScaleFactor(double scale) async {
    _textScaleFactor = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('text_scale_factor', scale);
    notifyListeners();
  }
  
  Future<void> setThemeColor(String colorValue) async {
    _themeColor = colorValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', colorValue);
    notifyListeners();
  }
  
  // ============ Privacy Settings ============
  
  Future<void> setAnalyticsEnabled(bool enabled) async {
    _analyticsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_enabled', enabled);
    notifyListeners();
  }
  
  Future<void> setPersonalizedAdsEnabled(bool enabled) async {
    _personalizedAdsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('personalized_ads', enabled);
    notifyListeners();
  }
  
  Future<void> setDataSharingEnabled(bool enabled) async {
    _dataSharingEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('data_sharing', enabled);
    notifyListeners();
  }
  
  // ============ Gameplay Settings ============
  
  Future<void> setAutoHintEnabled(bool enabled) async {
    _autoHintEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_hint', enabled);
    notifyListeners();
  }
  
  Future<void> setConfettiEnabled(bool enabled) async {
    _confettiEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('confetti_enabled', enabled);
    notifyListeners();
  }
  
  Future<void> setDefaultDifficulty(int difficulty) async {
    _defaultDifficulty = difficulty;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_difficulty', difficulty);
    notifyListeners();
  }
  
  // ============ Cache Management ============
  
  Future<void> clearCache() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      // Clear only cache-related data, not user progress
      await prefs.remove('cache_size');
      await prefs.remove('temp_data');
      
      _cacheSize = 0;
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> updateCacheSize(int size) async {
    _cacheSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cache_size', size);
    notifyListeners();
  }
  
  // ============ Reset Settings ============
  
  Future<void> resetAllSettings() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Reset to default values
      _soundEnabled = true;
      _musicEnabled = true;
      _soundVolume = 0.8;
      _musicVolume = 0.6;
      _vibrationEnabled = true;
      _pushNotificationsEnabled = true;
      _dailyReminderEnabled = true;
      _achievementAlertsEnabled = true;
      _dailyReminderTime = "09:00";
      _darkModeEnabled = false;
      _animationsEnabled = true;
      _textScaleFactor = 1.0;
      _themeColor = 'blue';
      _analyticsEnabled = true;
      _personalizedAdsEnabled = false;
      _dataSharingEnabled = true;
      _autoHintEnabled = false;
      _confettiEnabled = true;
      _defaultDifficulty = 1;
      
      // Save defaults to SharedPreferences
      await prefs.setBool(AppConstants.keySoundEnabled, true);
      await prefs.setBool(AppConstants.keyMusicEnabled, true);
      await prefs.setDouble('sound_volume', 0.8);
      await prefs.setDouble('music_volume', 0.6);
      await prefs.setBool(AppConstants.keyVibrationEnabled, true);
      await prefs.setBool('push_notifications', true);
      await prefs.setBool('daily_reminder', true);
      await prefs.setBool('achievement_alerts', true);
      await prefs.setString('daily_reminder_time', "09:00");
      await prefs.setBool('dark_mode', false);
      await prefs.setBool('animations_enabled', true);
      await prefs.setDouble('text_scale_factor', 1.0);
      await prefs.setString('theme_color', 'blue');
      await prefs.setBool('analytics_enabled', true);
      await prefs.setBool('personalized_ads', false);
      await prefs.setBool('data_sharing', true);
      await prefs.setBool('auto_hint', false);
      await prefs.setBool('confetti_enabled', true);
      await prefs.setInt('default_difficulty', 1);
      
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper: Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

// Theme color option model
class ThemeColorOption {
  final String name;
  final Color color;
  final String value;
  
  const ThemeColorOption({
    required this.name,
    required this.color,
    required this.value,
  });
}