import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/app_constants.dart';

class GameProvider extends ChangeNotifier {
  // Game state variables
  int _totalScore = 0;
  int _currentLevel = 1;
  int _collectedKeys = 0;
  List<int> _completedLevels = [];
  final Map<String, int> _subjectScores = {'Math': 0, 'English': 0, 'Science': 0};
  int _dailyStreak = 0;
  DateTime _lastPlayed = DateTime.now();
  bool _isLoading = false;
  
  // Power-ups and boosters
  int _availableHints = 3;
  int _extraLives = 0;
  bool _doubleXpActive = false;
  DateTime? _doubleXpExpiry;
  
  // Getter methods
  int get totalScore => _totalScore;
  int get currentLevel => _currentLevel;
  int get collectedKeys => _collectedKeys;
  List<int> get completedLevels => _completedLevels;
  Map<String, int> get subjectScores => _subjectScores;
  int get dailyStreak => _dailyStreak;
  bool get isLoading => _isLoading;
  int get availableHints => _availableHints;
  int get extraLives => _extraLives;
  bool get isDoubleXpActive => _doubleXpActive;
  
  // Computed properties
  int get xpForNextLevel => _currentLevel * AppConstants.xpPerLevel;
  int get currentLevelXp => _totalScore % AppConstants.xpPerLevel;
  double get levelProgress => currentLevelXp / AppConstants.xpPerLevel;
  double get overallProgress => _completedLevels.length / AppConstants.totalLevels;
  int get remainingKeys => AppConstants.totalKeysNeededForTreasure - _collectedKeys;
  bool get canOpenTreasure => _collectedKeys >= AppConstants.totalKeysNeededForTreasure;
  
  // Load game data from storage
  Future<void> loadGameData() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load basic stats
      _totalScore = prefs.getInt(AppConstants.keyTotalScore) ?? 0;
      _currentLevel = prefs.getInt(AppConstants.keyCurrentLevel) ?? 1;
      _collectedKeys = prefs.getInt(AppConstants.keyCollectedKeys) ?? 0;
      _dailyStreak = prefs.getInt(AppConstants.keyDailyStreak) ?? 0;
      
      // Load completed levels
      final completed = prefs.getStringList(AppConstants.keyCompletedLevels);
      if (completed != null) {
        _completedLevels = completed.map(int.parse).toList();
      }
      
      // Load subject scores
      final subjectScoresJson = prefs.getString(AppConstants.keySubjectScores);
      if (subjectScoresJson != null) {
        final Map<String, dynamic> scores = json.decode(subjectScoresJson);
        _subjectScores['Math'] = scores['Math'] ?? 0;
        _subjectScores['English'] = scores['English'] ?? 0;
        _subjectScores['Science'] = scores['Science'] ?? 0;
      }
      
      // Load last played date and update streak
      final lastPlayedStr = prefs.getString(AppConstants.keyLastPlayed);
      if (lastPlayedStr != null) {
        _lastPlayed = DateTime.parse(lastPlayedStr);
        _checkAndUpdateDailyStreak(prefs);
      }
      
      // Load power-ups
      _availableHints = prefs.getInt('available_hints') ?? 3;
      _extraLives = prefs.getInt('extra_lives') ?? 0;
      _doubleXpActive = prefs.getBool('double_xp_active') ?? false;
      final doubleXpExpiryStr = prefs.getString('double_xp_expiry');
      if (doubleXpExpiryStr != null && _doubleXpActive) {
        _doubleXpExpiry = DateTime.parse(doubleXpExpiryStr);
        if (DateTime.now().isAfter(_doubleXpExpiry!)) {
          _doubleXpActive = false;
          await prefs.setBool('double_xp_active', false);
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading game data: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Check and update daily streak
  Future<void> _checkAndUpdateDailyStreak(SharedPreferences prefs) async {
    final now = DateTime.now();
    final difference = now.difference(_lastPlayed).inDays;
    
    if (difference == 1) {
      // Consecutive day, increase streak
      _dailyStreak++;
      await prefs.setInt(AppConstants.keyDailyStreak, _dailyStreak);
      
      // Bonus for streak milestones
      if (_dailyStreak == 7) {
        await addScore(AppConstants.dailyStreakBonus * 2, 'Streak Bonus');
      } else if (_dailyStreak % 7 == 0) {
        await addScore(AppConstants.dailyStreakBonus, 'Streak Bonus');
      }
    } else if (difference > 1) {
      // Streak broken
      _dailyStreak = 0;
      await prefs.setInt(AppConstants.keyDailyStreak, 0);
    }
    
    _lastPlayed = now;
    await prefs.setString(AppConstants.keyLastPlayed, now.toIso8601String());
  }
  
  // Add score to total and subject
  Future<void> addScore(int points, String subject) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Apply double XP if active
    int finalPoints = points;
    if (_doubleXpActive) {
      finalPoints = points * 2;
    }
    
    _totalScore += finalPoints;
    _subjectScores[subject] = (_subjectScores[subject] ?? 0) + finalPoints;
    
    // Check for level up
    await _checkLevelUp(prefs);
    
    // Save to storage
    await prefs.setInt(AppConstants.keyTotalScore, _totalScore);
    await prefs.setInt(AppConstants.keyCurrentLevel, _currentLevel);
    await prefs.setString(
      AppConstants.keySubjectScores,
      json.encode(_subjectScores),
    );
    
    // Check for achievements
    await _checkAchievements(prefs);
    
    notifyListeners();
  }
  
  // Check if player leveled up
  Future<void> _checkLevelUp(SharedPreferences prefs) async {
    int newLevel = 1 + (_totalScore ~/ AppConstants.xpPerLevel);
    if (newLevel > _currentLevel) {
      _currentLevel = newLevel;
      await prefs.setInt(AppConstants.keyCurrentLevel, _currentLevel);
      
      // Reward for leveling up
      await addScore(100, 'Level Up');
    }
  }
  
  // Check and award achievements
  Future<void> _checkAchievements(SharedPreferences prefs) async {
    final earnedAchievements = prefs.getStringList('earned_achievements') ?? [];
    final newAchievements = <String>[];
    
    // Check score-based achievements
    if (_totalScore >= 100 && !earnedAchievements.contains('first_100')) {
      newAchievements.add('first_100');
      await addScore(50, 'Achievement');
    }
    if (_totalScore >= 500 && !earnedAchievements.contains('score_500')) {
      newAchievements.add('score_500');
      await addScore(100, 'Achievement');
    }
    if (_totalScore >= 1000 && !earnedAchievements.contains('score_1000')) {
      newAchievements.add('score_1000');
      await addScore(150, 'Achievement');
    }
    if (_totalScore >= 5000 && !earnedAchievements.contains('score_5000')) {
      newAchievements.add('score_5000');
      await addScore(500, 'Achievement');
    }
    
    // Check subject mastery achievements
    if (_subjectScores['Math']! >= 1000 && !earnedAchievements.contains('math_master')) {
      newAchievements.add('math_master');
    }
    if (_subjectScores['English']! >= 1000 && !earnedAchievements.contains('english_master')) {
      newAchievements.add('english_master');
    }
    if (_subjectScores['Science']! >= 1000 && !earnedAchievements.contains('science_master')) {
      newAchievements.add('science_master');
    }
    
    // Save new achievements
    if (newAchievements.isNotEmpty) {
      final allAchievements = [...earnedAchievements, ...newAchievements];
      await prefs.setStringList('earned_achievements', allAchievements);
    }
  }
  
  // Complete a level
  Future<void> completeLevel(int level) async {
    if (_completedLevels.contains(level)) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    _completedLevels.add(level);
    _collectedKeys++;
    
    // Reward for completing level
    final levelReward = level * 50;
    await addScore(levelReward, 'Level Completion');
    
    // Save to storage
    await prefs.setStringList(
      AppConstants.keyCompletedLevels,
      _completedLevels.map((e) => e.toString()).toList(),
    );
    await prefs.setInt(AppConstants.keyCollectedKeys, _collectedKeys);
    
    // Unlock next level if available
    if (level < AppConstants.totalLevels && !_completedLevels.contains(level + 1)) {
      // Next level is now unlocked
    }
    
    notifyListeners();
  }
  
  // Use a hint
  Future<bool> useHint() async {
    if (_availableHints <= 0) return false;
    
    final prefs = await SharedPreferences.getInstance();
    _availableHints--;
    await prefs.setInt('available_hints', _availableHints);
    notifyListeners();
    return true;
  }
  
  // Use extra life
  Future<bool> useExtraLife() async {
    if (_extraLives <= 0) return false;
    
    final prefs = await SharedPreferences.getInstance();
    _extraLives--;
    await prefs.setInt('extra_lives', _extraLives);
    notifyListeners();
    return true;
  }
  
  // Activate double XP
  Future<void> activateDoubleXp({int durationHours = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    _doubleXpActive = true;
    _doubleXpExpiry = DateTime.now().add(Duration(hours: durationHours));
    await prefs.setBool('double_xp_active', true);
    await prefs.setString('double_xp_expiry', _doubleXpExpiry!.toIso8601String());
    notifyListeners();
  }
  
  // Purchase power-up with coins
  Future<bool> purchasePowerUp(String powerUpType, int cost) async {
    if (_totalScore < cost) return false;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Deduct cost
    _totalScore -= cost;
    await prefs.setInt(AppConstants.keyTotalScore, _totalScore);
    
    // Add power-up
    switch (powerUpType) {
      case 'hint':
        _availableHints++;
        await prefs.setInt('available_hints', _availableHints);
        break;
      case 'extra_life':
        _extraLives++;
        await prefs.setInt('extra_lives', _extraLives);
        break;
      case 'double_xp':
        await activateDoubleXp();
        break;
    }
    
    notifyListeners();
    return true;
  }
  
  // Reset game progress (for testing)
  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    _totalScore = 0;
    _currentLevel = 1;
    _collectedKeys = 0;
    _completedLevels = [];
    _subjectScores['Math'] = 0;
    _subjectScores['English'] = 0;
    _subjectScores['Science'] = 0;
    _dailyStreak = 0;
    
    await prefs.setInt(AppConstants.keyTotalScore, 0);
    await prefs.setInt(AppConstants.keyCurrentLevel, 1);
    await prefs.setInt(AppConstants.keyCollectedKeys, 0);
    await prefs.remove(AppConstants.keyCompletedLevels);
    await prefs.setString(
      AppConstants.keySubjectScores,
      json.encode({'Math': 0, 'English': 0, 'Science': 0}),
    );
    await prefs.setInt(AppConstants.keyDailyStreak, 0);
    
    notifyListeners();
  }
  
  // Get subject score
  int getSubjectScore(String subject) {
    return _subjectScores[subject] ?? 0;
  }
  
  // Get total games played
  int getTotalGamesPlayed() {
    return _completedLevels.length * 3 + (_totalScore ~/ 100);
  }
  
  // Get earned badges count
  int getEarnedBadgesCount() {
    int count = 0;
    if (_totalScore >= 50) count++;
    if (_totalScore >= 500) count++;
    if (_totalScore >= 1000) count++;
    if (_totalScore >= 2000) count++;
    if (_totalScore >= 5000) count++;
    if (_totalScore >= 10000) count++;
    if (_subjectScores['Math']! >= 1000) count++;
    if (_subjectScores['English']! >= 1000) count++;
    if (_subjectScores['Science']! >= 1000) count++;
    if (_dailyStreak >= 7) count++;
    return count;
  }
  
  // Get rank title based on score
  String getRankTitle() {
    if (_totalScore >= 10000) return 'Legendary Master';
    if (_totalScore >= 5000) return 'Diamond Explorer';
    if (_totalScore >= 3500) return 'Platinum Adventurer';
    if (_totalScore >= 2000) return 'Gold Learner';
    if (_totalScore >= 1000) return 'Silver Student';
    if (_totalScore >= 500) return 'Bronze Beginner';
    return 'Novice Player';
  }
  
  // Get rank emoji
  String getRankEmoji() {
    if (_totalScore >= 10000) return '👑';
    if (_totalScore >= 5000) return '💎';
    if (_totalScore >= 3500) return '⭐';
    if (_totalScore >= 2000) return '🥇';
    if (_totalScore >= 1000) return '🥈';
    if (_totalScore >= 500) return '🥉';
    return '🌟';
  }
  
  // Helper: Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}