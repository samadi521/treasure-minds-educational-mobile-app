import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasure_minds/config/theme.dart';

class Helpers {
  // ============ Date Formatting ============
  
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }
  
  static String formatTime(DateTime time, {String pattern = 'hh:mm a'}) {
    return DateFormat(pattern).format(time);
  }
  
  static String formatDateTime(DateTime dateTime, {String pattern = 'MMM dd, yyyy hh:mm a'}) {
    return DateFormat(pattern).format(dateTime);
  }
  
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
  
  // ============ Number Formatting ============
  
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
  
  static String formatScore(int score) {
    return NumberFormat('#,###').format(score);
  }
  
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
  
  static String formatTimeDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  // ============ String Helpers ============
  
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String capitalizeEachWord(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }
  
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  static bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }
  
  // ============ Color Helpers ============
  
  static Color lightenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
  
  static Color darkenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
  
  static Color hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  // ============ Size Helpers ============
  
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
  
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  // ============ Random Helpers ============
  
  static int randomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }
  
  static double randomDouble(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }
  
  static T randomItem<T>(List<T> items) {
    if (items.isEmpty) throw Exception('Cannot get random item from empty list');
    return items[Random().nextInt(items.length)];
  }
  
  static List<T> shuffleList<T>(List<T> items) {
    final shuffled = List<T>.from(items);
    shuffled.shuffle();
    return shuffled;
  }
  
  // ============ Validation Helpers ============
  
  static bool isBetween(int value, int min, int max) {
    return value >= min && value <= max;
  }
  
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
  
  static bool isListNullOrEmpty(List? list) {
    return list == null || list.isEmpty;
  }
  
  // ============ File Size Helpers ============
  
  static String formatFileSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
  
  // ============ Progress Helpers ============
  
  static double calculateProgress(int current, int total) {
    if (total == 0) return 0;
    return (current / total).clamp(0.0, 1.0);
  }
  
  static String getProgressPercentage(int current, int total) {
    return '${(calculateProgress(current, total) * 100).toInt()}%';
  }
  
  // ============ Grade Helpers ============
  
  static String getGradeFromAge(int age) {
    if (age <= 5) return 'Preschool';
    if (age == 6) return 'Grade 1';
    if (age == 7) return 'Grade 2';
    if (age == 8) return 'Grade 3';
    if (age == 9) return 'Grade 4';
    if (age == 10) return 'Grade 5';
    if (age == 11) return 'Grade 6';
    if (age == 12) return 'Grade 7';
    if (age == 13) return 'Grade 8';
    if (age == 14) return 'Grade 9';
    if (age == 15) return 'Grade 10';
    if (age == 16) return 'Grade 11';
    return 'High School';
  }
  
  static String getDifficultyFromAge(int age) {
    if (age <= 8) return 'Easy';
    if (age <= 11) return 'Medium';
    if (age <= 14) return 'Hard';
    return 'Expert';
  }
  
  // ============ XP Level Helpers ============
  
  static int getLevelFromXP(int xp) {
    return 1 + (xp ~/ 500);
  }
  
  static int getXPForLevel(int level) {
    return level * 500;
  }
  
  static int getXPToNextLevel(int currentXP) {
    final currentLevel = getLevelFromXP(currentXP);
    final nextLevelXP = getXPForLevel(currentLevel + 1);
    return nextLevelXP - currentXP;
  }
  
  static double getLevelProgress(int currentXP) {
    final currentLevel = getLevelFromXP(currentXP);
    final currentLevelXP = getXPForLevel(currentLevel);
    final nextLevelXP = getXPForLevel(currentLevel + 1);
    return (currentXP - currentLevelXP) / (nextLevelXP - currentLevelXP);
  }
  
  // ============ Streak Helpers ============
  
  static String getStreakEmoji(int streak) {
    if (streak >= 100) return '🔥🔥🔥';
    if (streak >= 50) return '🔥🔥';
    if (streak >= 30) return '🔥';
    if (streak >= 14) return '⭐';
    if (streak >= 7) return '🌟';
    if (streak >= 3) return '✨';
    return '💪';
  }
  
  static String getStreakMessage(int streak) {
    if (streak == 0) return 'Start your streak today!';
    if (streak < 3) return 'Keep going!';
    if (streak < 7) return 'Great consistency!';
    if (streak < 14) return 'You\'re on fire!';
    if (streak < 30) return 'Amazing dedication!';
    return 'Legendary streak!';
  }
  
  // ============ Score Helpers ============
  
  static String getScoreRank(int score) {
    if (score >= 10000) return 'Legend';
    if (score >= 5000) return 'Master';
    if (score >= 2000) return 'Expert';
    if (score >= 1000) return 'Advanced';
    if (score >= 500) return 'Intermediate';
    if (score >= 100) return 'Beginner';
    return 'Novice';
  }
  
  static Color getScoreColor(int score) {
    if (score >= 10000) return AppColors.gold;
    if (score >= 5000) return AppColors.neonPurple;
    if (score >= 2000) return AppColors.neonBlue;
    if (score >= 1000) return AppColors.mintGreen;
    if (score >= 500) return AppColors.warningOrange;
    return Colors.grey;
  }
  
  // ============ Navigation Helpers ============
  
  static Future<T?> pushPage<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  static void pushReplacementPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  static void pushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
  
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
  
  // ============ Dialog Helpers ============
  
  static Future<void> showLoadingDialog(BuildContext context, {String message = 'Loading...'}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
  
  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppColors.neonBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppColors.errorRed);
  }
  
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppColors.mintGreen);
  }
}

// Extension methods for easier access
extension StringExtension on String {
  String get capitalized => Helpers.capitalize(this);
  String get capitalizedWords => Helpers.capitalizeEachWord(this);
  String truncate(int maxLength, {String suffix = '...'}) => Helpers.truncate(this, maxLength, suffix: suffix);
  bool get isValidEmail => Helpers.isValidEmail(this);
  bool get isValidPassword => Helpers.isValidPassword(this);
  bool get isValidUsername => Helpers.isValidUsername(this);
  bool get isNullOrEmpty => Helpers.isNullOrEmpty(this);
}

extension IntExtension on int {
  String get formatNumber => Helpers.formatNumber(this);
  String get formatScore => Helpers.formatScore(this);
  String get formatFileSize => Helpers.formatFileSize(this);
  String formatTimeDuration() => Helpers.formatTimeDuration(this);
  bool isBetween(int min, int max) => Helpers.isBetween(this, min, max);
  double getProgress(int total) => Helpers.calculateProgress(this, total);
  String getProgressPercentage(int total) => Helpers.getProgressPercentage(this, total);
  int get level => Helpers.getLevelFromXP(this);
  int xpToNextLevel() => Helpers.getXPToNextLevel(this);
  double get levelProgress => Helpers.getLevelProgress(this);
  String get scoreRank => Helpers.getScoreRank(this);
  Color get scoreColor => Helpers.getScoreColor(this);
}

extension DoubleExtension on double {
  String get formatPercentage => Helpers.formatPercentage(this);
}

extension DateTimeExtension on DateTime {
  String formatDate({String pattern = 'MMM dd, yyyy'}) => Helpers.formatDate(this, pattern: pattern);
  String formatTime({String pattern = 'hh:mm a'}) => Helpers.formatTime(this, pattern: pattern);
  String formatDateTime({String pattern = 'MMM dd, yyyy hh:mm a'}) => Helpers.formatDateTime(this, pattern: pattern);
  String get timeAgo => Helpers.getTimeAgo(this);
}

extension ColorExtension on Color {
  Color lighten([double amount = 0.2]) => Helpers.lightenColor(this, amount);
  Color darken([double amount = 0.2]) => Helpers.darkenColor(this, amount);
  String get toHex => Helpers.colorToHex(this);
}

extension ListExtension<T> on List<T> {
  T get random => Helpers.randomItem(this);
  List<T> get shuffled => Helpers.shuffleList(this);
  bool get isNullOrEmpty => Helpers.isListNullOrEmpty(this);
}

extension ContextExtension on BuildContext {
  bool get isSmallScreen => Helpers.isSmallScreen(this);
  bool get isMediumScreen => Helpers.isMediumScreen(this);
  bool get isLargeScreen => Helpers.isLargeScreen(this);
  double get screenWidth => Helpers.getScreenWidth(this);
  double get screenHeight => Helpers.getScreenHeight(this);
  
  void showSnackBar(String message, {Color? backgroundColor}) => 
      Helpers.showSnackBar(this, message, backgroundColor: backgroundColor);
  void showErrorSnackBar(String message) => Helpers.showErrorSnackBar(this, message);
  void showSuccessSnackBar(String message) => Helpers.showSuccessSnackBar(this, message);
  
  Future<T?> pushPage<T>(Widget page) => Helpers.pushPage<T>(this, page);
  void pushReplacementPage(Widget page) => Helpers.pushReplacementPage(this, page);
  void pushAndRemoveUntil(Widget page) => Helpers.pushAndRemoveUntil(this, page);
  void pop([dynamic result]) => Helpers.pop(this, result);
}
