import 'package:flutter/material.dart';
import 'package:treasure_minds/config/theme.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final String? avatarUrl;
  final int avatarIndex;
  final String avatarName;
  final DateTime createdAt;
  final DateTime lastLogin;
  final int totalScore;
  final int currentLevel;
  final int collectedKeys;
  final List<int> completedLevels;
  final Map<String, int> subjectScores;
  final int dailyStreak;
  final List<String> earnedAchievements;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.avatarUrl,
    required this.avatarIndex,
    required this.avatarName,
    required this.createdAt,
    required this.lastLogin,
    required this.totalScore,
    required this.currentLevel,
    required this.collectedKeys,
    required this.completedLevels,
    required this.subjectScores,
    required this.dailyStreak,
    required this.earnedAchievements,
    required this.preferences,
  });

  // Create empty user
  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      age: 0,
      avatarIndex: 0,
      avatarName: 'Explorer',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      totalScore: 0,
      currentLevel: 1,
      collectedKeys: 0,
      completedLevels: [],
      subjectScores: {'Math': 0, 'English': 0, 'Science': 0},
      dailyStreak: 0,
      earnedAchievements: [],
      preferences: {},
    );
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
      avatarIndex: json['avatarIndex'] as int? ?? 0,
      avatarName: json['avatarName'] as String? ?? 'Explorer',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      lastLogin: DateTime.parse(json['lastLogin'] as String? ?? DateTime.now().toIso8601String()),
      totalScore: json['totalScore'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
      collectedKeys: json['collectedKeys'] as int? ?? 0,
      completedLevels: (json['completedLevels'] as List<dynamic>?)?.cast<int>() ?? [],
      subjectScores: Map<String, int>.from(json['subjectScores'] as Map? ?? {'Math': 0, 'English': 0, 'Science': 0}),
      dailyStreak: json['dailyStreak'] as int? ?? 0,
      earnedAchievements: (json['earnedAchievements'] as List<dynamic>?)?.cast<String>() ?? [],
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'avatarUrl': avatarUrl,
      'avatarIndex': avatarIndex,
      'avatarName': avatarName,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'totalScore': totalScore,
      'currentLevel': currentLevel,
      'collectedKeys': collectedKeys,
      'completedLevels': completedLevels,
      'subjectScores': subjectScores,
      'dailyStreak': dailyStreak,
      'earnedAchievements': earnedAchievements,
      'preferences': preferences,
    };
  }

  // Copy with modifications
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? avatarUrl,
    int? avatarIndex,
    String? avatarName,
    DateTime? createdAt,
    DateTime? lastLogin,
    int? totalScore,
    int? currentLevel,
    int? collectedKeys,
    List<int>? completedLevels,
    Map<String, int>? subjectScores,
    int? dailyStreak,
    List<String>? earnedAchievements,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      avatarName: avatarName ?? this.avatarName,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      totalScore: totalScore ?? this.totalScore,
      currentLevel: currentLevel ?? this.currentLevel,
      collectedKeys: collectedKeys ?? this.collectedKeys,
      completedLevels: completedLevels ?? this.completedLevels,
      subjectScores: subjectScores ?? this.subjectScores,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      earnedAchievements: earnedAchievements ?? this.earnedAchievements,
      preferences: preferences ?? this.preferences,
    );
  }

  // Computed properties
  int get totalGamesPlayed => completedLevels.length * 3 + (totalScore ~/ 100);
  
  int get earnedBadgesCount {
    int count = 0;
    if (totalScore >= 50) count++;
    if (totalScore >= 500) count++;
    if (totalScore >= 1000) count++;
    if (totalScore >= 2000) count++;
    if (totalScore >= 5000) count++;
    if (totalScore >= 10000) count++;
    if (subjectScores['Math']! >= 1000) count++;
    if (subjectScores['English']! >= 1000) count++;
    if (subjectScores['Science']! >= 1000) count++;
    if (dailyStreak >= 7) count++;
    return count;
  }
  
  double get overallProgress => completedLevels.length / 8;
  
  int get totalBadges => 10;
  
  String get rankTitle {
    if (totalScore >= 10000) return 'Legendary Master';
    if (totalScore >= 5000) return 'Diamond Explorer';
    if (totalScore >= 3500) return 'Platinum Adventurer';
    if (totalScore >= 2000) return 'Gold Learner';
    if (totalScore >= 1000) return 'Silver Student';
    if (totalScore >= 500) return 'Bronze Beginner';
    return 'Novice Player';
  }
  
  String get rankEmoji {
    if (totalScore >= 10000) return '👑';
    if (totalScore >= 5000) return '💎';
    if (totalScore >= 3500) return '⭐';
    if (totalScore >= 2000) return '🥇';
    if (totalScore >= 1000) return '🥈';
    if (totalScore >= 500) return '🥉';
    return '🌟';
  }
  
  Color get rankColor {
    if (totalScore >= 10000) return AppColors.gold;
    if (totalScore >= 5000) return AppColors.neonCyan;
    if (totalScore >= 3500) return AppColors.neonBlue;
    if (totalScore >= 2000) return AppColors.gold;
    if (totalScore >= 1000) return AppColors.silver;
    if (totalScore >= 500) return AppColors.bronze;
    return AppColors.neonGreen;
  }
  
  bool get hasCompletedAllLevels => completedLevels.length >= 8;
  
  bool get canOpenTreasure => collectedKeys >= 5;
  
  int get xpForNextLevel => currentLevel * 500;
  
  int get currentLevelXp => totalScore % 500;
  
  double get levelProgress => currentLevelXp / xpForNextLevel;
  
  // Methods
  bool hasCompletedLevel(int level) => completedLevels.contains(level);
  
  int getSubjectScore(String subject) => subjectScores[subject] ?? 0;
  
  bool hasEarnedAchievement(String achievementId) => earnedAchievements.contains(achievementId);
  
  UserModel updateLastLogin() {
    return copyWith(lastLogin: DateTime.now());
  }
  
  UserModel addScore(int points, String subject) {
    final newSubjectScores = Map<String, int>.from(subjectScores);
    newSubjectScores[subject] = (newSubjectScores[subject] ?? 0) + points;
    
    int newTotalScore = totalScore + points;
    int newLevel = 1 + (newTotalScore ~/ 500);
    
    return copyWith(
      totalScore: newTotalScore,
      currentLevel: newLevel,
      subjectScores: newSubjectScores,
    );
  }
  
  UserModel completeLevel(int level) {
    if (completedLevels.contains(level)) return this;
    
    final newCompletedLevels = List<int>.from(completedLevels)..add(level);
    final newCollectedKeys = collectedKeys + 1;
    
    return copyWith(
      completedLevels: newCompletedLevels,
      collectedKeys: newCollectedKeys,
    );
  }
  
  UserModel updateStreak() {
    final now = DateTime.now();
    final difference = now.difference(lastLogin).inDays;
    
    int newStreak = dailyStreak;
    if (difference == 1) {
      newStreak++;
    } else if (difference > 1) {
      newStreak = 0;
    }
    
    return copyWith(
      dailyStreak: newStreak,
      lastLogin: now,
    );
  }
  
  UserModel addAchievement(String achievementId) {
    if (earnedAchievements.contains(achievementId)) return this;
    
    final newAchievements = List<String>.from(earnedAchievements)..add(achievementId);
    return copyWith(earnedAchievements: newAchievements);
  }
  
  UserModel updatePreferences(Map<String, dynamic> newPreferences) {
    final updatedPreferences = Map<String, dynamic>.from(preferences)..addAll(newPreferences);
    return copyWith(preferences: updatedPreferences);
  }
}

// User preferences model
class UserPreferences {
  bool soundEnabled;
  bool musicEnabled;
  bool vibrationEnabled;
  bool notificationsEnabled;
  String language;
  String theme;
  double textScaleFactor;

  UserPreferences({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.vibrationEnabled = true,
    this.notificationsEnabled = true,
    this.language = 'en',
    this.theme = 'light',
    this.textScaleFactor = 1.0,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'light',
      textScaleFactor: json['textScaleFactor'] as double? ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'vibrationEnabled': vibrationEnabled,
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'theme': theme,
      'textScaleFactor': textScaleFactor,
    };
  }

  UserPreferences copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    String? language,
    String? theme,
    double? textScaleFactor,
  }) {
    return UserPreferences(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}

// User session model
class UserSession {
  final String userId;
  final String token;
  final DateTime expiresAt;
  final bool isActive;

  UserSession({
    required this.userId,
    required this.token,
    required this.expiresAt,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      userId: json['userId'] as String,
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  UserSession copyWith({bool? isActive}) {
    return UserSession(
      userId: userId,
      token: token,
      expiresAt: expiresAt,
      isActive: isActive ?? this.isActive,
    );
  }
}