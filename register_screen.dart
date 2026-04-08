import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../config/theme.dart';
import 'login_screen.dart';
import '../home/home_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  int _selectedAge = 8;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: AppColors.errorRed),
      );
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'), backgroundColor: AppColors.errorRed),
      );
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: AppColors.errorRed),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      _selectedAge,
    );

    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            opacity: _animationController,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      alignment: Alignment.centerLeft,
                    ),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 10, color: Colors.black26, offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                    const Text(
                      'Join the adventure!',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_nameController, 'Full Name', Icons.person, false),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', Icons.email, false),
                    const SizedBox(height: 16),
                    _buildAgeSelector(),
                    const SizedBox(height: 16),
                    _buildTextField(_passwordController, 'Password', Icons.lock, true,
                        obscure: _obscurePassword,
                        onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword)),
                    const SizedBox(height: 16),
                    _buildTextField(_confirmController, 'Confirm Password', Icons.lock, true,
                        obscure: _obscureConfirm,
                        onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm)),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: _register,
                      isLoading: Provider.of<AuthProvider>(context).isLoading,
                      backgroundColor: Colors.white,
                      textColor: AppColors.neonPurple,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildAgeSelector() {
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
      child: DropdownButtonFormField<int>(
        initialValue: _selectedAge,
        decoration: const InputDecoration(
          labelText: 'Age',
          labelStyle: TextStyle(color: AppColors.neonPurple),
          prefixIcon: Icon(Icons.cake, color: AppColors.neonPurple),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: Colors.white,
        items: List.generate(11, (i) => i + 6).map((age) {
          return DropdownMenuItem(
            value: age,
            child: Text('$age years old', style: const TextStyle(color: AppColors.neonPurple)),
          );
        }).toList(),
        onChanged: (value) => setState(() => _selectedAge = value!),
        selectedItemBuilder: (context) => List.generate(11, (i) => i + 6).map((age) {
          return Text('$age years old', style: const TextStyle(color: AppColors.neonPurple));
        }).toList(),
      ),
    );
  }
}
