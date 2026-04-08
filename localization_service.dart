import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  LocalizationService(this.locale);

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('si'), // Sinhala
    Locale('ta'), // Tamil
  ];

  // Supported language codes
  static const List<String> supportedLanguages = ['en', 'si', 'ta'];
  
  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'si': 'සිංහල',
    'ta': 'தமிழ்',
  };
  
  // Native language names
  static const Map<String, String> nativeLanguageNames = {
    'en': 'English',
    'si': 'සිංහල',
    'ta': 'தமிழ்',
  };
  
  // Flag emojis
  static const Map<String, String> flagEmojis = {
    'en': '🇬🇧',
    'si': '🇱🇰',
    'ta': '🇱🇰',
  };
  
  // Text directions
  static const Map<String, TextDirection> textDirections = {
    'en': TextDirection.ltr,
    'si': TextDirection.ltr,
    'ta': TextDirection.ltr,
  };

  // Localization delegate
  static const LocalizationsDelegate<LocalizationService> delegate = _LocalizationDelegate();

   static LocalizationService of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService)!;
  }

  // Load localized strings from JSON file
  Future<bool> load() async {
    try {
      String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      return true;
    } catch (e) {
      debugPrint('Error loading localization for ${locale.languageCode}: $e');
      // Fallback to English
      String jsonString = await rootBundle.loadString('assets/lang/en.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      return false;
    }
  }

  // Get localized string by key
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Get localized string with arguments
  String translateWithArgs(String key, List<String> args) {
    String text = _localizedStrings[key] ?? key;
    for (int i = 0; i < args.length; i++) {
      text = text.replaceAll('{$i}', args[i]);
    }
    return text;
  }

  // Check if translation exists
  bool hasTranslation(String key) {
    return _localizedStrings.containsKey(key);
  }

  // Get current language code
  String get currentLanguageCode => locale.languageCode;
  
  // Get current language name
  String get currentLanguageName => languageNames[locale.languageCode] ?? 'English';
  
  // Get current native language name
  String get currentNativeLanguageName => nativeLanguageNames[locale.languageCode] ?? 'English';
  
  // Get current flag emoji
  String get currentFlagEmoji => flagEmojis[locale.languageCode] ?? '🇬🇧';
  
  // Check if RTL
  bool get isRTL => textDirections[locale.languageCode] == TextDirection.rtl;
  
  // Get text direction
  TextDirection get textDirection => textDirections[locale.languageCode] ?? TextDirection.ltr;
}

// Localization delegate
class _LocalizationDelegate extends LocalizationsDelegate<LocalizationService> {
  const _LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocalizationService.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    LocalizationService localizations = LocalizationService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}

// Extension for BuildContext to easily access localization
extension LocalizationExtension on BuildContext {
  LocalizationService get localization => Localizations.of<LocalizationService>(this, LocalizationService)!;
  
  String tr(String key) => localization.translate(key);
  
  String trArgs(String key, List<String> args) => localization.translateWithArgs(key, args);
  
  String get currentLanguageCode => localization.currentLanguageCode;
  
  String get currentLanguageName => localization.currentLanguageName;
  
  String get currentFlagEmoji => localization.currentFlagEmoji;
  
  bool get isRTL => localization.isRTL;
  
  TextDirection get textDirection => localization.textDirection;
}

// Localization keys constants
class LocKeys {
  // App
  static const String appName = 'app_name';
  static const String welcome = 'welcome';
  static const String welcomeBack = 'welcome_back';
  
  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String email = 'email';
  static const String password = 'password';
  static const String confirmPassword = 'confirm_password';
  static const String fullName = 'full_name';
  static const String age = 'age';
  static const String rememberMe = 'remember_me';
  static const String forgotPassword = 'forgot_password';
  static const String dontHaveAccount = 'dont_have_account';
  static const String alreadyHaveAccount = 'already_have_account';
  static const String signUp = 'sign_up';
  static const String orLoginWith = 'or_login_with';
  
  // Game
  static const String play = 'play';
  static const String learn = 'learn';
  static const String explore = 'explore';
  static const String adventure = 'adventure';
  static const String math = 'math';
  static const String english = 'english';
  static const String science = 'science';
  static const String dailyChallenge = 'daily_challenge';
  static const String timerChallenge = 'timer_challenge';
  static const String leaderboard = 'leaderboard';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String rewards = 'rewards';
  static const String badges = 'badges';
  static const String progress = 'progress';
  
  // Gameplay
  static const String score = 'score';
  static const String level = 'level';
  static const String lives = 'lives';
  static const String timeLeft = 'time_left';
  static const String gameOver = 'game_over';
  static const String victory = 'victory';
  static const String treasureFound = 'treasure_found';
  static const String combo = 'combo';
  static const String multiplier = 'multiplier';
  
  // Language
  static const String selectLanguage = 'select_language';
  static const String sinhala = 'sinhala';
  static const String tamil = 'tamil';
  static const String englishLang = 'english_lang';
  
  // Actions
  static const String continuePlaying = 'continue_playing';
  static const String newGame = 'new_game';
  static const String tryAgain = 'try_again';
  static const String claimRewards = 'claim_rewards';
  static const String back = 'back';
  static const String next = 'next';
  static const String submit = 'submit';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  
  // Status
  static const String loading = 'loading';
  static const String noInternet = 'no_internet';
  static const String errorOccurred = 'error_occurred';
  static const String success = 'success';
  static const String congratulations = 'congratulations';
  static const String goodJob = 'good_job';
  static const String keepGoing = 'keep_going';
  static const String perfect = 'perfect';
  static const String awesome = 'awesome';
  
  // Stats
  static const String streak = 'streak';
  static const String dailyStreak = 'daily_streak';
  static const String totalScore = 'total_score';
  static const String gamesPlayed = 'games_played';
  static const String keysCollected = 'keys_collected';
  static const String treasureChest = 'treasure_chest';
  static const String unlock = 'unlock';
  static const String locked = 'locked';
  static const String completed = 'completed';
  static const String inProgress = 'in_progress';
  
  // Selection
  static const String selectSubject = 'select_subject';
  static const String selectGrade = 'select_grade';
  static const String selectLevel = 'select_level';
  static const String gameModes = 'game_modes';
}

// Language change notifier
class LanguageChangeNotifier extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  
  Locale get currentLocale => _currentLocale;
  
  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }
}

// Localization helper methods
class LocalizationHelper {
  // Format number according to locale
  static String formatNumber(int number, String languageCode) {
    switch (languageCode) {
      case 'si':
      case 'ta':
        return number.toString();
      default:
        return number.toString();
    }
  }
  
  // Format date according to locale
  static String formatDate(DateTime date, String languageCode) {
    switch (languageCode) {
      case 'si':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      case 'ta':
        return '${date.day}/${date.month}/${date.year}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }
  
  // Get localized weekday name
  static String getWeekdayName(int weekday, String languageCode) {
    const englishWeekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const sinhalaWeekdays = ['සඳුදා', 'අඟහරුවාදා', 'බදාදා', 'බ්‍රහස්පතින්දා', 'සිකුරාදා', 'සෙනසුරාදා', 'ඉරිදා'];
    const tamilWeekdays = ['திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி', 'ஞாயிறு'];
    
    switch (languageCode) {
      case 'si':
        return sinhalaWeekdays[weekday - 1];
      case 'ta':
        return tamilWeekdays[weekday - 1];
      default:
        return englishWeekdays[weekday - 1];
    }
  }
  
  // Get localized month name
  static String getMonthName(int month, String languageCode) {
    const englishMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    const sinhalaMonths = ['ජනවාරි', 'පෙබරවාරි', 'මාර්තු', 'අප්‍රේල්', 'මැයි', 'ජූනි', 'ජූලි', 'අගෝස්තු', 'සැප්තැම්බර්', 'ඔක්තෝබර්', 'නොවැම්බර්', 'දෙසැම්බර්'];
    const tamilMonths = ['ஜனவரி', 'பிப்ரவரி', 'மார்ச்', 'ஏப்ரல்', 'மே', 'ஜூன்', 'ஜூலை', 'ஆகஸ்ட்', 'செப்டம்பர்', 'அக்டோபர்', 'நவம்பர்', 'டிசம்பர்'];
    
    switch (languageCode) {
      case 'si':
        return sinhalaMonths[month - 1];
      case 'ta':
        return tamilMonths[month - 1];
      default:
        return englishMonths[month - 1];
    }
  }
}