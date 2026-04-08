class AppConstants {
  static const String appName = "Treasure Minds";
  static const String appVersion = "1.0.0";
  
  // Storage Keys
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyUserEmail = 'userEmail';
  static const String keyUserName = 'userName';
  static const String keyUserAge = 'userAge';
  static const String keyUserAvatar = 'userAvatar';
  static const String keyLanguage = 'selected_language';
  static const String keyTotalScore = 'totalScore';
  static const String keyCurrentLevel = 'currentLevel';
  static const String keyCollectedKeys = 'collectedKeys';
  static const String keyCompletedLevels = 'completedLevels';
  static const String keyDailyStreak = 'dailyStreak';
  static const String keyLastPlayed = 'lastPlayed';
  static const String keySubjectScores = 'subjectScores';
  static const String keySelectedAvatar = 'selectedAvatar';
  static const String keyAvatarName = 'avatarName';
  static const String keyAvatarColor = 'avatarColor';
  static const String keySoundEnabled = 'soundEnabled';
  static const String keyMusicEnabled = 'musicEnabled';
  static const String keyVibrationEnabled = 'vibrationEnabled';
  static const String keyNotificationsEnabled = 'notificationsEnabled';
  
  // Game Settings
  static const int maxLives = 3;
  static const int dailyStreakBonus = 50;
  static const int correctAnswerPoints = 10;
  static const int timeBonusMultiplier = 2;
  
  // Level Settings
  static const int totalLevels = 8;
  static const int keysPerLevel = 3;
  static const int totalKeysNeededForTreasure = 5;
  static const int xpPerLevel = 500;
  
  // Quiz Settings
  static const int dailyQuizQuestions = 7;
  static const int timerChallengeSeconds = 60;
  static const int questionsPerGame = 10;
  
  // Achievement Thresholds
  static const int bronzeBadgePoints = 500;
  static const int silverBadgePoints = 1000;
  static const int goldBadgePoints = 2000;
  static const int diamondBadgePoints = 5000;
  static const int legendaryBadgePoints = 10000;
  
  // Subject Names
  static const List<String> subjects = ['Math', 'English', 'Science'];
  
  // Grade Levels
  static const List<String> primaryGrades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'];
  static const List<String> secondaryGrades = ['Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11'];
  
  // Level Names
  static const Map<int, String> levelNames = {
    1: 'Novice Explorer',
    2: 'Apprentice Adventurer',
    3: 'Skillful Seeker',
    4: 'Expert Navigator',
    5: 'Master Treasure Hunter',
    6: 'Grand Discovery',
    7: 'Legendary Pioneer',
    8: 'Ultimate Champion',
  };
  
  // Avatar Options
  static const List<Map<String, dynamic>> avatars = [
    {'name': 'Captain Alex', 'color': 0xFFFF6B6B, 'icon': 'emoji_emotions', 'emoji': '👨‍✈️'},
    {'name': 'Wizard Emma', 'color': 0xFF9B5DE5, 'icon': 'auto_awesome', 'emoji': '🧙‍♀️'},
    {'name': 'Knight Leo', 'color': 0xFF4ECDC4, 'icon': 'shield', 'emoji': '⚔️'},
    {'name': 'Pirate Jack', 'color': 0xFFFF9F1C, 'icon': 'sailing', 'emoji': '🏴‍☠️'},
    {'name': 'Princess Mia', 'color': 0xFFFF85A1, 'icon': 'workspace_premium', 'emoji': '👸'},
    {'name': 'Robot Bot', 'color': 0xFF6BCB77, 'icon': 'android', 'emoji': '🤖'},
    {'name': 'Dragon Blaze', 'color': 0xFFFF9800, 'icon': 'whatshot', 'emoji': '🐉'},
    {'name': 'Fairy Lily', 'color': 0xFF87CEEB, 'icon': 'auto_awesome', 'emoji': '🧚‍♀️'},
    {'name': 'Ninja Shadow', 'color': 0xFF2C3E50, 'icon': 'sports_mma', 'emoji': '🥷'},
    {'name': 'Mermaid Coral', 'color': 0xFF00CED1, 'icon': 'beach_access', 'emoji': '🧜‍♀️'},
  ];
  
  // Puzzle Difficulty Settings
  static const Map<String, int> puzzlePoints = {
    'Easy': 15,
    'Medium': 20,
    'Hard': 25,
    'Very Hard': 30,
  };
  
  // Badge Definitions
  static const List<Map<String, dynamic>> badges = [
    {'id': 1, 'name': 'First Victory', 'description': 'Complete your first game', 'icon': 'emoji_events', 'points': 50},
    {'id': 2, 'name': 'Math Master', 'description': 'Score 1000 in Math', 'icon': 'calculate', 'points': 1000},
    {'id': 3, 'name': 'Book Worm', 'description': 'Score 1000 in English', 'icon': 'menu_book', 'points': 1000},
    {'id': 4, 'name': 'Science Whiz', 'description': 'Score 1000 in Science', 'icon': 'science', 'points': 1000},
    {'id': 5, 'name': 'Streak Master', 'description': '7 day streak', 'icon': 'local_fire_department', 'points': 7},
    {'id': 6, 'name': 'Key Collector', 'description': 'Collect 5 keys', 'icon': 'key', 'points': 5},
    {'id': 7, 'name': 'Explorer', 'description': 'Complete all levels', 'icon': 'map', 'points': 8},
    {'id': 8, 'name': 'Legendary', 'description': 'Score 5000 points', 'icon': 'diamond', 'points': 5000},
    {'id': 9, 'name': 'Speed Demon', 'description': 'Answer 10 questions fast', 'icon': 'timer', 'points': 500},
    {'id': 10, 'name': 'Puzzle Master', 'description': 'Solve 10 puzzles', 'icon': 'psychology', 'points': 10},
  ];
}