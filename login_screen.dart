import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../services/localization_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';
import '../../config/theme.dart';
import 'register_screen.dart';
import '../home/home_dashboard.dart';
import '../settings/language_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password'), backgroundColor: AppColors.errorRed),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(_emailController.text, _passwordController.text);

    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password'), backgroundColor: AppColors.errorRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = LocalizationService.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.rainbowGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Treasure Minds',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 10, color: Colors.black26, offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.translate('welcome'),
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    // Email Field
                    _buildTextField(
                      _emailController,
                      localizations.translate('email'),
                      Icons.email,
                      false,
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    _buildTextField(
                      _passwordController,
                      localizations.translate('password'),
                      Icons.lock,
                      true,
                      obscure: _obscurePassword,
                      onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 16),
                    // Remember me & Forgot password - FIXED OVERFLOW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) => setState(() => _rememberMe = value ?? false),
                                activeColor: Colors.white,
                                checkColor: AppColors.neonPurple,
                              ),
                              Flexible(
                                child: Text(
                                  localizations.translate('remember_me'),
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            localizations.translate('forgot_password'),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    CustomButton(
                      text: localizations.translate('login'),
                      onPressed: _login,
                      isLoading: Provider.of<AuthProvider>(context).isLoading,
                      backgroundColor: Colors.white,
                      textColor: AppColors.neonPurple,
                    ),
                    const SizedBox(height: 20),
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            localizations.translate('dont_have_account'),
                            style: const TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                          },
                          child: Text(
                            localizations.translate('sign_up'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Or login with
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR', style: TextStyle(color: Colors.white)),
                        ),
                        Expanded(child: Divider(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Social Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          icon: Icons.g_mobiledata,
                          color: Colors.red,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coming Soon!')),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        SocialLoginButton(
                          icon: Icons.facebook,
                          color: const Color(0xFF1877F2),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coming Soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Language Selector
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language, color: AppColors.neonPurple),
                            const SizedBox(width: 8),
                            Text(
                              languageProvider.getLanguageName(),
                              style: const TextStyle(color: AppColors.neonPurple),
                            ),
                            const Icon(Icons.arrow_drop_down, color: AppColors.neonPurple),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isPassword, {
    bool obscure = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && obscure,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.neonPurple),
          prefixIcon: Icon(icon, color: AppColors.neonPurple),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.neonPurple),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
