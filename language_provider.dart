import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  bool _isRTL = false;
  
  // Supported locales with full details
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('si'), // Sinhala
    Locale('ta'), // Tamil
  ];
  
  static const Map<String, LanguageInfo> languageInfo = {
    'en': LanguageInfo(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flagEmoji: '🇬🇧',
      direction: TextDirection.ltr,
      fontFamily: 'Poppins',
    ),
    'si': LanguageInfo(
      code: 'si',
      name: 'Sinhala',
      nativeName: 'සිංහල',
      flagEmoji: '🇱🇰',
      direction: TextDirection.ltr,
      fontFamily: 'NotoSansSinhala',
    ),
    'ta': LanguageInfo(
      code: 'ta',
      name: 'Tamil',
      nativeName: 'தமிழ்',
      flagEmoji: '🇱🇰',
      direction: TextDirection.ltr,
      fontFamily: 'NotoSansTamil',
    ),
  };
  
  // Getter methods
  Locale get currentLocale => _currentLocale;
  bool get isRTL => _isRTL;
  String get currentLanguageCode => _currentLocale.languageCode;
  
  LanguageInfo? get currentLanguageInfo => languageInfo[currentLanguageCode];
  
  // Constructor
  LanguageProvider() {
    _loadSavedLanguage();
  }
  
  // Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(AppConstants.keyLanguage);
      
      if (savedLanguage != null && _isSupportedLanguage(savedLanguage)) {
        await setLocale(Locale(savedLanguage), saveToPrefs: false);
      } else {
        // Default to device locale if supported, otherwise English
        final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        if (deviceLocale != null && _isSupportedLanguage(deviceLocale.languageCode)) {
          await setLocale(Locale(deviceLocale.languageCode), saveToPrefs: false);
        } else {
          await setLocale(const Locale('en'), saveToPrefs: false);
        }
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
      await setLocale(const Locale('en'), saveToPrefs: false);
    }
  }
  
  // Set application locale
  Future<void> setLocale(Locale locale, {bool saveToPrefs = true}) async {
    if (!_isSupportedLanguage(locale.languageCode)) {
      debugPrint('Unsupported language: ${locale.languageCode}, falling back to English');
      locale = const Locale('en');
    }
    
    _currentLocale = locale;
    final languageInfoValue = languageInfo[locale.languageCode];
    _isRTL = languageInfoValue?.direction == TextDirection.rtl;
    
    if (saveToPrefs) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLanguage, locale.languageCode);
    }
    
    notifyListeners();
  }
  
  // Check if language is supported
  bool _isSupportedLanguage(String languageCode) {
    return supportedLocales.any((locale) => locale.languageCode == languageCode);
  }
  
  // Get language name in native format
  String getNativeLanguageName() {
    return languageInfo[currentLanguageCode]?.nativeName ?? 'English';
  }
  
  // Get language name in English
  String getLanguageName() {
    return languageInfo[currentLanguageCode]?.name ?? 'English';
  }
  
  // Get flag emoji for current language
  String getFlagEmoji() {
    return languageInfo[currentLanguageCode]?.flagEmoji ?? '🇬🇧';
  }
  
  // Get font family for current language
  String getFontFamily() {
    return languageInfo[currentLanguageCode]?.fontFamily ?? 'Poppins';
  }
  
  // Get all supported languages list
  List<LanguageInfo> getSupportedLanguages() {
    return supportedLocales
        .map((locale) => languageInfo[locale.languageCode])
        .where((info) => info != null)
        .cast<LanguageInfo>()
        .toList();
  }
  
  // Translate text (to be used with localization service)
  String translate(String key, {List<String>? args}) {
    // This method will be implemented with the localization service
    // For now, return the key itself
    // In production, this would use the LocalizationService
    return key;
  }
  
  // Get localized number formatting
  String formatNumber(int number) {
    // Different cultures format numbers differently
    switch (currentLanguageCode) {
      case 'si':
      case 'ta':
        return number.toString(); // Use same formatting for now
      default:
        return number.toString();
    }
  }
  
  // Get localized date formatting
  String formatDate(DateTime date) {
    switch (currentLanguageCode) {
      case 'si':
        return '${date.day}/${date.month}/${date.year}';
      case 'ta':
        return '${date.day}/${date.month}/${date.year}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }
  
  // Get direction for text alignment
  TextDirection getTextDirection() {
    return _isRTL ? TextDirection.rtl : TextDirection.ltr;
  }
  
  // Get alignment based on language direction
  Alignment getAlignment() {
    return _isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }
  
  // Get cross axis alignment for RTL support
  CrossAxisAlignment getCrossAxisAlignment() {
    return _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }
  
  // Get main axis alignment for RTL support
  MainAxisAlignment getMainAxisAlignment() {
    return _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start;
  }
}

// Language information model
class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final TextDirection direction;
  final String fontFamily;
  
  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    required this.direction,
    required this.fontFamily,
  });
}

// Extension for BuildContext to easily access language provider
extension LanguageContextExtension on BuildContext {
  LanguageProvider get languageProvider => Provider.of<LanguageProvider>(this, listen: false);
  
  LanguageProvider watchLanguageProvider() => Provider.of<LanguageProvider>(this, listen: true);
  
  bool get isRTL => languageProvider.isRTL;
  
  String get currentLanguage => languageProvider.currentLanguageCode;
  
  String translate(String key, {List<String>? args}) {
    return languageProvider.translate(key, args: args);
  }
}

// Localization keys constants
class LocalizationKeys {
  static const String appName = 'app_name';
  static const String welcome = 'welcome';
  static const String welcomeBack = 'welcome_back';
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
  static const String score = 'score';
  static const String level = 'level';
  static const String lives = 'lives';
  static const String timeLeft = 'time_left';
  static const String gameOver = 'game_over';
  static const String victory = 'victory';
  static const String treasureFound = 'treasure_found';
  static const String combo = 'combo';
  static const String multiplier = 'multiplier';
  static const String selectLanguage = 'select_language';
  static const String sinhala = 'sinhala';
  static const String tamil = 'tamil';
  static const String englishLang = 'english_lang';
  static const String continuePlaying = 'continue_playing';
  static const String newGame = 'new_game';
  static const String tryAgain = 'try_again';
  static const String claimRewards = 'claim_rewards';
  static const String back = 'back';
  static const String next = 'next';
  static const String submit = 'submit';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  static const String loading = 'loading';
  static const String noInternet = 'no_internet';
  static const String errorOccurred = 'error_occurred';
  static const String success = 'success';
  static const String congratulations = 'congratulations';
  static const String goodJob = 'good_job';
  static const String keepGoing = 'keep_going';
  static const String perfect = 'perfect';
  static const String awesome = 'awesome';
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
  static const String selectSubject = 'select_subject';
  static const String selectGrade = 'select_grade';
  static const String selectLevel = 'select_level';
  static const String gameModes = 'game_modes';
}

// Language change notifier for widget rebuilds
class LanguageChangeNotifier extends ChangeNotifier {
  void onLanguageChanged() {
    notifyListeners();
  }
}