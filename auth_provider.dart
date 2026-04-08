import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;
  int _userAge = 0;
  String? _userId;
  String? _userAvatar;
  bool _isLoading = false;
  String? _errorMessage;
  
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  int get userAge => _userAge;
  String? get userId => _userId;
  String? get userAvatar => _userAvatar;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  AuthProvider() {
    checkAuthStatus();
  }
  
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
      _userName = prefs.getString(AppConstants.keyUserName);
      _userEmail = prefs.getString(AppConstants.keyUserEmail);
      _userAge = prefs.getInt(AppConstants.keyUserAge) ?? 0;
      _userId = prefs.getString('userId');
      _userAvatar = prefs.getString(AppConstants.keyUserAvatar);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error checking auth status: $e';
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      if (email.isEmpty) {
        _errorMessage = 'Please enter your email';
        return false;
      }
      if (password.isEmpty) {
        _errorMessage = 'Please enter your password';
        return false;
      }
      
      await _authService.signInWithEmail(email, password);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await prefs.setString(AppConstants.keyUserEmail, email);
      await prefs.setString(AppConstants.keyUserName, email.split('@').first);
      await prefs.setString('userId', _authService.currentUser?.uid ?? '');
      
      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@').first;
      _userId = _authService.currentUser?.uid;
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> register(String name, String email, String password, int age) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      if (name.isEmpty) {
        _errorMessage = 'Please enter your name';
        return false;
      }
      if (name.length < 2) {
        _errorMessage = 'Name must be at least 2 characters';
        return false;
      }
      if (email.isEmpty) {
        _errorMessage = 'Please enter your email';
        return false;
      }
      if (password.isEmpty) {
        _errorMessage = 'Please enter a password';
        return false;
      }
      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        return false;
      }
      if (age < 6 || age > 16) {
        _errorMessage = 'Age must be between 6 and 16';
        return false;
      }
      
      await _authService.registerWithEmail(email, password, name, age);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await prefs.setString(AppConstants.keyUserEmail, email);
      await prefs.setString(AppConstants.keyUserName, name);
      await prefs.setInt(AppConstants.keyUserAge, age);
      await prefs.setString('userId', _authService.currentUser?.uid ?? '');
      
      await _initializeGameData(prefs);
      
      _isLoggedIn = true;
      _userEmail = email;
      _userName = name;
      _userAge = age;
      _userId = _authService.currentUser?.uid;
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _initializeGameData(SharedPreferences prefs) async {
    if (!prefs.containsKey(AppConstants.keyTotalScore)) {
      await prefs.setInt(AppConstants.keyTotalScore, 0);
    }
    if (!prefs.containsKey(AppConstants.keyCurrentLevel)) {
      await prefs.setInt(AppConstants.keyCurrentLevel, 1);
    }
    if (!prefs.containsKey(AppConstants.keyCollectedKeys)) {
      await prefs.setInt(AppConstants.keyCollectedKeys, 0);
    }
    if (!prefs.containsKey(AppConstants.keyDailyStreak)) {
      await prefs.setInt(AppConstants.keyDailyStreak, 0);
    }
  }
  
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyIsLoggedIn);
      await prefs.remove(AppConstants.keyUserEmail);
      await prefs.remove(AppConstants.keyUserName);
      await prefs.remove('userId');
      
      _isLoggedIn = false;
      _userName = null;
      _userEmail = null;
      _userAge = 0;
      _userId = null;
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateProfile(String name, int age) async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (name.isNotEmpty) {
        await prefs.setString(AppConstants.keyUserName, name);
        _userName = name;
      }
      if (age >= 6 && age <= 16) {
        await prefs.setInt(AppConstants.keyUserAge, age);
        _userAge = age;
      }
      
      if (_userId != null) {
        await _authService.updateUserProfile(name: name, age: age);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Profile update failed: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateAvatar(String avatarPath) async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserAvatar, avatarPath);
      _userAvatar = avatarPath;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Avatar update failed: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      if (email.isEmpty) {
        _errorMessage = 'Please enter your email';
        return false;
      }
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _errorMessage = 'Password reset failed: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}