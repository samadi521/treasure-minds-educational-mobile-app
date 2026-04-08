import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/game_models.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  // Game progress operations
  Future<void> updateGameProgress(
    String userId, {
    required int totalScore,
    required int currentLevel,
    required int collectedKeys,
    required List<int> completedLevels,
    required Map<String, int> subjectScores,
    required int dailyStreak,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'totalScore': totalScore,
      'currentLevel': currentLevel,
      'collectedKeys': collectedKeys,
      'completedLevels': completedLevels,
      'subjectScores': subjectScores,
      'dailyStreak': dailyStreak,
      'lastLogin': DateTime.now().toIso8601String(),
    });
  }

  // Leaderboard operations
  Stream<List<LeaderboardEntry>> getGlobalLeaderboard() {
    return _firestore
        .collection('users')
        .orderBy('totalScore', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaderboardEntry(
          userId: doc.id,
          name: data['name'] ?? '',
          score: data['totalScore'] ?? 0,
          level: data['currentLevel'] ?? 1,
          avatar: data['avatarName']?[0]?.toUpperCase() ?? '?',
        );
      }).toList();
    });
  }

  // Subject leaderboard
  Stream<List<LeaderboardEntry>> getSubjectLeaderboard(String subject) {
    return _firestore
        .collection('users')
        .orderBy('subjectScores.$subject', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaderboardEntry(
          userId: doc.id,
          name: data['name'] ?? '',
          score: (data['subjectScores'] as Map?)?[subject] ?? 0,
          level: data['currentLevel'] ?? 1,
          avatar: data['avatarName']?[0]?.toUpperCase() ?? '?',
        );
      }).toList();
    });
  }

  // Achievements
  Future<List<Achievement>> getUserAchievements(String userId) async {
    final doc = await _firestore
        .collection('achievements')
        .doc(userId)
        .get();
    
    if (doc.exists) {
      final data = doc.data()!;
      return (data['achievements'] as List?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [];
    }
    return [];
  }

  Future<void> unlockAchievement(String userId, String achievementId) async {
    await _firestore.collection('achievements').doc(userId).set({
      'achievements': FieldValue.arrayUnion([achievementId]),
    }, SetOptions(merge: true));
  }

  // Daily challenge
  Future<DailyChallenge?> getDailyChallenge(String userId) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final doc = await _firestore
        .collection('dailyChallenges')
        .doc('$userId-$today')
        .get();
    
    if (doc.exists) {
      return DailyChallenge.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> completeDailyChallenge(String userId, int score) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await _firestore.collection('dailyChallenges').doc('$userId-$today').set({
      'userId': userId,
      'date': today,
      'completed': true,
      'score': score,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }
}

class LeaderboardEntry {
  final String userId;
  final String name;
  final int score;
  final int level;
  final String avatar;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.score,
    required this.level,
    required this.avatar,
  });
}