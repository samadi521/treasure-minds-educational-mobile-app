import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/language_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Select Language"),
        backgroundColor: AppColors.neonBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildLanguageCard(
                  languageCode: 'en',
                  languageName: 'English',
                  nativeName: 'English',
                  flagEmoji: '🇬🇧',
                  flagIcon: Icons.language,
                  color: AppColors.neonBlue,
                  description: 'Global language for learning',
                  isSelected: languageProvider.currentLocale.languageCode == 'en',
                  onTap: () {
                    languageProvider.setLocale(const Locale('en'));
                    _showSuccessMessage('English selected');
                  },
                ),
                const SizedBox(height: 15),
                _buildLanguageCard(
                  languageCode: 'si',
                  languageName: 'Sinhala',
                  nativeName: 'සිංහල',
                  flagEmoji: '🇱🇰',
                  flagIcon: Icons.translate,
                  color: AppColors.mathOrange,
                  description: 'Sri Lankan national language',
                  isSelected: languageProvider.currentLocale.languageCode == 'si',
                  onTap: () {
                    languageProvider.setLocale(const Locale('si'));
                    _showSuccessMessage('Sinhala selected');
                  },
                ),
                const SizedBox(height: 15),
                _buildLanguageCard(
                  languageCode: 'ta',
                  languageName: 'Tamil',
                  nativeName: 'தமிழ்',
                  flagEmoji: '🇱🇰',
                  flagIcon: Icons.translate,
                  color: AppColors.sciencePurple,
                  description: 'Sri Lankan Tamil language',
                  isSelected: languageProvider.currentLocale.languageCode == 'ta',
                  onTap: () {
                    languageProvider.setLocale(const Locale('ta'));
                    _showSuccessMessage('Tamil selected');
                  },
                ),
                const SizedBox(height: 30),
                _buildInfoCard(),
                const SizedBox(height: 30),
                _buildPreviewSection(languageProvider),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.neonPurple, AppColors.lavenderPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.language,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Choose Your Language',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Select your preferred language for the app',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flagEmoji,
    required IconData flagIcon,
    required Color color,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Flag/Icon Circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected
                      ? [color, color.withValues(alpha: 0.7)]
                      : [AppColors.neonBlue, AppColors.neonPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  flagEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 15),
            
            // Language Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? color.withValues(alpha: 0.8) : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? color.withValues(alpha: 0.7) : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Checkmark if selected
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: AppColors.gold, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Language Support',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.neonPurple,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'All game content, questions, and UI will be displayed in your selected language.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildPreviewSection(LanguageProvider languageProvider) {
    final isRTL = languageProvider.isRTL;
    final currentLocale = languageProvider.currentLocale;
    final languageCode = currentLocale.languageCode;
    
    // Determine welcome text
    String welcomeText;
    if (languageCode == 'en') {
      welcomeText = 'Welcome, Player!';
    } else if (languageCode == 'si') {
      welcomeText = 'සාදරයෙන් පිළිගනිමු, ක්‍රීඩකයා!';
    } else {
      welcomeText = 'வரவேற்கிறோம், வீரரே!';
    }
    
    // Determine start text
    String startText;
    if (languageCode == 'en') {
      startText = 'Let\'s start learning!';
    } else if (languageCode == 'si') {
      startText = 'අපි ඉගෙනීම ආරම්භ කරමු!';
    } else {
      startText = 'கற்றலை ஆரம்பிப்போம்!';
    }
    
    // Determine button texts
    String playText;
    if (languageCode == 'en') {
      playText = 'Play';
    } else if (languageCode == 'si') {
      playText = 'සෙල්ලම් කරන්න';
    } else {
      playText = 'விளையாடு';
    }
    
    String learnText;
    if (languageCode == 'en') {
      learnText = 'Learn';
    } else if (languageCode == 'si') {
      learnText = 'ඉගෙන ගන්න';
    } else {
      learnText = 'கற்றுக்கொள்';
    }
    
    String exploreText;
    if (languageCode == 'en') {
      exploreText = 'Explore';
    } else if (languageCode == 'si') {
      exploreText = 'ගවේෂණය කරන්න';
    } else {
      exploreText = 'ஆராய்';
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.preview, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.neonBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              welcomeText,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              startText,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildPreviewChip(playText, AppColors.mathOrange),
                    _buildPreviewChip(learnText, AppColors.englishGreen),
                    _buildPreviewChip(exploreText, AppColors.sciencePurple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text('✓ $message'),
            ],
          ),
          backgroundColor: AppColors.mintGreen,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Go back after selection
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }
}
