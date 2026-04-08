import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme.dart';
import 'config/app_constants.dart';
import 'config/firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/game_provider.dart';
import 'providers/language_provider.dart';
import 'providers/avatar_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Try to initialize Firebase but don't let it crash the app
  await Firebase.initializeApp();
  
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString(AppConstants.keyLanguage) ?? 'en';
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
  
  runApp(TreasureMindsApp(
    savedLocale: savedLocale,
    hasSeenOnboarding: hasSeenOnboarding,
  ));
}

class TreasureMindsApp extends StatelessWidget {
  final String savedLocale;
  final bool hasSeenOnboarding;
  
  const TreasureMindsApp({
    super.key,
    required this.savedLocale,
    required this.hasSeenOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => GameProvider()..loadGameData()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..setLocale(Locale(savedLocale))),
        ChangeNotifierProvider(create: (_) => AvatarProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: languageProvider.currentLocale,
            supportedLocales: const [Locale('en'), Locale('si'), Locale('ta')],
            localizationsDelegates: const [
              // Temporarily comment out custom localization to avoid errors
              // LocalizationService.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: SplashScreen(
              isLoggedIn: false,
              hasSeenOnboarding: hasSeenOnboarding,
            ),
          );
        },
      ),
    );
  }
}