import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Register with email and password
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
    String name,
    int age,
  ) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Create user document in Firestore
    if (userCredential.user != null) {
      final userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        age: age,
        avatarIndex: 0,
        avatarName: name,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        totalScore: 0,
        currentLevel: 1,
        collectedKeys: 0,
        completedLevels: [],
        subjectScores: {'Math': 0, 'English': 0, 'Science': 0},
        dailyStreak: 1,
        earnedAchievements: [],
        preferences: {},
      );
      
      await _firestore.collection('users').doc(userCredential.user!.uid).set(
        userModel.toJson(),
      );
    }
    
    return userCredential;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    int? age,
    int? avatarIndex,
    String? avatarName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (age != null) updates['age'] = age;
    if (avatarIndex != null) updates['avatarIndex'] = avatarIndex;
    if (avatarName != null) updates['avatarName'] = avatarName;
    
    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).update(updates);
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    // Delete user document from Firestore
    await _firestore.collection('users').doc(user.uid).delete();
    
    // Delete authentication account
    await user.delete();
  }
}