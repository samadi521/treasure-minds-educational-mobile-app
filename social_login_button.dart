import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? label;
  final double size;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.label,
    this.size = 60,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      // Full width button with label
      return GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        label!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ).animate().scale(duration: 200.ms).fadeIn();
    }

    // Circular icon button
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                ),
              )
            : Icon(icon, color: color, size: size * 0.45),
      ),
    ).animate().scale(duration: 200.ms).fadeIn();
  }
}

// Google Sign In Button
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isCompact;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return SocialLoginButton(
        icon: Icons.g_mobiledata,
        color: Colors.red,
        onTap: onPressed,
        isLoading: isLoading,
        size: 50,
      );
    }
    
    return SocialLoginButton(
      icon: Icons.g_mobiledata,
      color: Colors.red,
      onTap: onPressed,
      label: 'Continue with Google',
      isLoading: isLoading,
    );
  }
}

// Facebook Sign In Button
class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isCompact;

  const FacebookSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return SocialLoginButton(
        icon: Icons.facebook,
        color: const Color(0xFF1877F2),
        onTap: onPressed,
        isLoading: isLoading,
        size: 50,
      );
    }
    
    return SocialLoginButton(
      icon: Icons.facebook,
      color: const Color(0xFF1877F2),
      onTap: onPressed,
      label: 'Continue with Facebook',
      isLoading: isLoading,
    );
  }
}

// Apple Sign In Button
class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isCompact;

  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return SocialLoginButton(
        icon: Icons.apple,
        color: Colors.black,
        onTap: onPressed,
        isLoading: isLoading,
        size: 50,
      );
    }
    
    return SocialLoginButton(
      icon: Icons.apple,
      color: Colors.black,
      onTap: onPressed,
      label: 'Continue with Apple',
      isLoading: isLoading,
    );
  }
}

// Microsoft Sign In Button
class MicrosoftSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const MicrosoftSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      icon: Icons.window,
      color: const Color(0xFF00A4EF),
      onTap: onPressed,
      label: 'Continue with Microsoft',
      isLoading: isLoading,
    );
  }
}

// Twitter Sign In Button
class TwitterSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const TwitterSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      icon: Icons.chat_bubble_outline,
      color: const Color(0xFF1DA1F2),
      onTap: onPressed,
      label: 'Continue with Twitter',
      isLoading: isLoading,
    );
  }
}

// Social login row with multiple buttons
class SocialLoginRow extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;
  final VoidCallback onApplePressed;
  final bool isLoading;

  const SocialLoginRow({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    required this.onApplePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GoogleSignInButton(
          onPressed: onGooglePressed,
          isLoading: isLoading,
          isCompact: true,
        ),
        const SizedBox(width: 16),
        FacebookSignInButton(
          onPressed: onFacebookPressed,
          isLoading: isLoading,
          isCompact: true,
        ),
        const SizedBox(width: 16),
        AppleSignInButton(
          onPressed: onApplePressed,
          isLoading: isLoading,
          isCompact: true,
        ),
      ],
    );
  }
}

// Social login divider with "or" text
class SocialLoginDivider extends StatelessWidget {
  final String text;

  const SocialLoginDivider({
    super.key,
    this.text = 'Or continue with',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
      ],
    );
  }
}

// Social login section with all options
class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;
  final VoidCallback onApplePressed;
  final bool isLoading;

  const SocialLoginSection({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    required this.onApplePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SocialLoginDivider(),
        const SizedBox(height: 20),
        SocialLoginRow(
          onGooglePressed: onGooglePressed,
          onFacebookPressed: onFacebookPressed,
          onApplePressed: onApplePressed,
          isLoading: isLoading,
        ),
      ],
    );
  }
}

// Social login button with custom styling
class CustomSocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomSocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// Animated social login button
class AnimatedSocialButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AnimatedSocialButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<AnimatedSocialButton> createState() => _AnimatedSocialButtonState();
}

class _AnimatedSocialButtonState extends State<AnimatedSocialButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.color, size: 28),
            ),
          );
        },
      ),
    );
  }
}