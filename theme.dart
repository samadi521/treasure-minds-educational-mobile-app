import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const List<Color> rainbowGradient = [
    Color(0xFFFF6B6B),  // Bright Red
    Color(0xFFFF9F1C),  // Bright Orange
    Color(0xFFFFE66D),  // Bright Yellow
    Color(0xFF6BCB77),  // Bright Green
    Color(0xFF4ECDC4),  // Bright Cyan/Teal
    Color(0xFF9B5DE5),  // Bright Purple
  ];
  
  static const List<Color> pastelRainbow = [
    Color(0xFFFFB3BA),  // Pastel Red
    Color(0xFFFFDFBA),  // Pastel Orange
    Color(0xFFFFFACD),  // Pastel Yellow
    Color(0xFFB5EAD7),  // Pastel Green
    Color(0xFFC7CEEA),  // Pastel Blue
    Color(0xFFE0BBE4),  // Pastel Purple
  ];
  
  static const Color brightRed = Color(0xFFFF4757);
  static const Color brightOrange = Color(0xFFFFA502);
  static const Color brightYellow = Color(0xFFFFD32A);
  static const Color brightGreen = Color(0xFF20BF6B);
  static const Color brightCyan = Color(0xFF0ABDE3);
  static const Color brightBlue = Color(0xFF2E86DE);
  static const Color brightPurple = Color(0xFF8854D0);
  static const Color brightPink = Color(0xFFFD9644);
  static const Color brightLime = Color(0xFFA5F1E9);
  static const Color brightMagenta = Color(0xFFD980FA);
  static const Color brightCoral = Color(0xFFFF6B81);
  static const Color brightMint = Color(0xFF78E08F);
  
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color diamond = Color(0xFFB9F2FF);
  
  static const Color mathOrange = Color(0xFFFFA502);
  static const Color englishGreen = Color(0xFF20BF6B);
  static const Color sciencePurple = Color(0xFF8854D0);
  static const Color adventureTeal = Color(0xFF0ABDE3);
  static const Color puzzlePink = Color(0xFFFF6B81);
  static const Color challengeRed = Color(0xFFFF4757);
  
  static const Color successGreen = Color(0xFF20BF6B);
  static const Color errorRed = Color(0xFFFF4757);
  static const Color warningOrange = Color(0xFFFFA502);
  static const Color infoBlue = Color(0xFF2E86DE);
  
  static const Color bubblegumPink = Color(0xFFFF6B81);
  static const Color lavenderPurple = Color(0xFFD980FA);
  static const Color sunnyYellow = Color(0xFFFFD32A);
  static const Color mintGreen = Color(0xFF78E08F);
  static const Color oceanBlue = Color(0xFF0ABDE3);
  static const Color coralOrange = Color(0xFFFF7F50);
  
  static const Color neonGreen = Color(0xFF0BE881);
  static const Color neonBlue = Color(0xFF1E90FF);
  static const Color neonPink = Color(0xFFFF69B4);
  static const Color neonYellow = Color(0xFFF5E56B);
  static const Color neonOrange = Color(0xFFFF7F50);
  static const Color neonPurple = Color(0xFFB983FF);
  static const Color neonCyan = Color(0xFF00CED1);
  
  static const Color backgroundLight = Color(0xFFF0F8FF);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color cardWhite = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.neonBlue,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.neonBlue,
      secondary: AppColors.neonOrange,
      tertiary: AppColors.neonGreen,
      surface: Colors.white,
      error: AppColors.errorRed,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brightBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 3,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white.withAlpha(242),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.brightBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.neonPurple,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.neonBlue,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.neonGreen,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.neonPurple,
        fontFamily: 'ComicNeue',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.brightBlue,
        fontFamily: 'ComicNeue',
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.neonOrange,
        fontFamily: 'Poppins',
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.neonBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.neonGreen,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.neonOrange,
      circularTrackColor: Colors.white24,
    ),
    
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.neonPurple,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
    
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.neonBlue,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
    ),
    
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.neonPurple,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.neonOrange,
      dividerColor: Colors.transparent,
    ),
    
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.neonGreen),
      trackColor: WidgetStatePropertyAll(AppColors.neonOrange.withAlpha(128)),
    ),
    
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.neonBlue),
      checkColor: WidgetStatePropertyAll(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.neonGreen),
    ),
    
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.neonOrange,
      inactiveTrackColor: Colors.grey,
      thumbColor: AppColors.neonOrange,
      overlayColor: AppColors.neonOrange,
    ),
  );
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.rainbowGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
        centerTitle: centerTitle,
        elevation: elevation,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}