import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class ColorfulButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool isOutlined;
  final double fontSize;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  
  const ColorfulButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.isOutlined = false,
    this.fontSize = 18,
    this.borderRadius,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 55;
    final buttonBorderRadius = borderRadius ?? BorderRadius.circular(30);
    
    Widget buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: 24, color: isOutlined ? color : Colors.white),
          const SizedBox(width: 10),
        ],
        if (isLoading)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        else
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isOutlined ? color : Colors.white,
            ),
          ),
      ],
    );
    
    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: buttonBorderRadius,
            ),
          ),
          child: buttonChild,
        ),
      ).animate().scale(duration: 200.ms).fadeIn();
    }
    
    // Check if gradient should be used
    final useGradient = gradientColors != null && gradientColors!.length >= 2;
    
    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: useGradient ? null : color,
          foregroundColor: Colors.white,
          shadowColor: color.withValues(alpha: 0.3),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorderRadius,
          ),
        ),
        child: useGradient
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors!,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: buttonBorderRadius,
                ),
                child: Center(child: buttonChild),
              )
            : buttonChild,
      ),
    ).animate().scale(duration: 200.ms).fadeIn();
  }
}

// Gradient button with multiple color options
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> colors;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  
  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.colors,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: colors.first,
      icon: icon,
      isLoading: isLoading,
      width: width,
      height: height,
      gradientColors: colors,
    );
  }
}

// Rainbow gradient button
class RainbowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  
  const RainbowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: AppColors.gold,
      icon: icon,
      isLoading: isLoading,
      width: width,
      height: height,
      gradientColors: AppColors.rainbowGradient,
    );
  }
}

// Icon button with colorful background
class ColorfulIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final double iconSize;
  final bool isLoading;
  
  const ColorfulIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.size = 56,
    this.iconSize = 28,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  icon,
                  size: iconSize,
                  color: Colors.white,
                ),
        ),
      ),
    ).animate().scale(duration: 200.ms).fadeIn();
  }
}

// Button with shine animation effect
class ShineButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  
  const ShineButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
  });

  @override
  State<ShineButton> createState() => _ShineButtonState();
}

class _ShineButtonState extends State<ShineButton> with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
    _shineController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color, widget.color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _shineAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: _shineAnimation.value * 200,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Button variants for different contexts
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: AppColors.neonBlue,
      icon: icon,
      isLoading: isLoading,
    );
  }
}

class SuccessButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const SuccessButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: AppColors.mintGreen,
      icon: icon,
      isLoading: isLoading,
    );
  }
}

class WarningButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const WarningButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: AppColors.warningOrange,
      icon: icon,
      isLoading: isLoading,
    );
  }
}

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const DangerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: AppColors.errorRed,
      icon: icon,
      isLoading: isLoading,
    );
  }
}

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const GoldButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColorfulButton(
      text: text,
      onPressed: onPressed,
      color: AppColors.gold,
      icon: icon,
      isLoading: isLoading,
      gradientColors: [AppColors.gold, AppColors.warningOrange],
    );
  }
}