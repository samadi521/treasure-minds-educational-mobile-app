import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double fontSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isExpanded;
  final double elevation;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.icon,
    this.fontSize = 16,
    this.borderRadius,
    this.padding,
    this.isExpanded = true,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? AppColors.neonBlue;
    final buttonTextColor = textColor ?? Colors.white;
    final buttonBorderRadius = borderRadius ?? BorderRadius.circular(25);
    
    Widget buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: 20, color: buttonTextColor),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: buttonTextColor,
            ),
          )
        else
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: buttonTextColor,
            ),
          ),
      ],
    );

    // If outlined button (border color provided)
    if (borderColor != null) {
      return SizedBox(
        width: width,
        height: height ?? 50,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonTextColor,
            side: BorderSide(color: borderColor!, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: buttonBorderRadius,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            elevation: elevation,
          ),
          child: buttonChild,
        ),
      ).animate().scale(duration: 200.ms).fadeIn();
    }

    // Regular filled button
    return SizedBox(
      width: width,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorderRadius,
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: elevation,
        ),
        child: buttonChild,
      ),
    ).animate().scale(duration: 200.ms).fadeIn();
  }
}

// Icon button with text
class IconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  
  const IconTextButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.neonBlue;
    
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: buttonColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: buttonColor, width: 1),
            ),
            child: Icon(icon, color: buttonColor, size: size * 0.45),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: buttonColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Rounded button with shadow
class ShadowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final double borderRadius;
  
  const ShadowButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Text button with underline
class UnderlineTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  
  const UnderlineTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: color ?? AppColors.neonBlue,
          decoration: TextDecoration.underline,
          decorationColor: color ?? AppColors.neonBlue,
        ),
      ),
    );
  }
}

// Button with countdown timer
class CountdownButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final int countdownSeconds;
  final Color color;
  
  const CountdownButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.countdownSeconds = 3,
    this.color = AppColors.neonBlue,
  });

  @override
  State<CountdownButton> createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  int _remainingSeconds = 0;
  bool _isCountingDown = false;
  
  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _remainingSeconds = widget.countdownSeconds;
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 1) {
            _remainingSeconds--;
          } else {
            _isCountingDown = false;
            widget.onPressed();
          }
        });
      }
      return _isCountingDown && mounted;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: _isCountingDown ? '$_remainingSeconds...' : widget.text,
      onPressed: _isCountingDown ? () {} : _startCountdown,
      backgroundColor: _isCountingDown ? Colors.grey : widget.color,
    );
  }
}

// Social media login button
class SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  
  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: color,
      borderColor: color,
      icon: icon,
    );
  }
}

// Google Sign In Button
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      text: 'Sign in with Google',
      icon: Icons.g_mobiledata,
      color: Colors.red,
      onPressed: onPressed,
    );
  }
}

// Facebook Sign In Button
class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  
  const FacebookSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      text: 'Sign in with Facebook',
      icon: Icons.facebook,
      color: const Color(0xFF1877F2),
      onPressed: onPressed,
    );
  }
}

// Apple Sign In Button
class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  
  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Sign in with Apple',
      onPressed: onPressed,
      backgroundColor: Colors.black,
      icon: Icons.apple,
    );
  }
}

// Button with icon on right side
class RightIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  
  const RightIconButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.neonBlue;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Close button with custom styling
class CloseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;
  
  const CloseButton({
    super.key,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? Colors.grey).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: color ?? Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}

// Back button with custom styling
class BackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;
  
  const BackButton({
    super.key,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? Colors.grey).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back,
          color: color ?? Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}