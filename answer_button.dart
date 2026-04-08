import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final int index;
  final Color color;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool showResult;
  final bool isCorrect;
  final bool isEnabled;
  final double width;
  final double height;

  const AnswerButton({
    super.key,
    required this.text,
    required this.index,
    required this.color,
    required this.onPressed,
    this.isSelected = false,
    this.showResult = false,
    this.isCorrect = false,
    this.isEnabled = true,
    this.width = double.infinity,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode(65 + index); // A, B, C, D
    
    Color getButtonColor() {
      if (!isEnabled) return Colors.grey.shade400;
      if (showResult) {
        if (isCorrect) return AppColors.mintGreen;
        if (isSelected && !isCorrect) return AppColors.errorRed;
      }
      if (isSelected) return color;
      return color.withValues(alpha: 0.85);
    }

    Color getTextColor() {
      if (!isEnabled) return Colors.grey.shade600;
      if (showResult && (isCorrect || (isSelected && !isCorrect))) {
        return Colors.white;
      }
      return Colors.white;
    }

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [getButtonColor(), getButtonColor().withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: getButtonColor().withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isSelected && !showResult
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Letter circle
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: isSelected && !showResult
                    ? Border.all(color: Colors.white, width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Answer text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: getTextColor(),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Status icon
            if (showResult && (isCorrect || (isSelected && !isCorrect)))
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              
            // Loading indicator if needed
            if (!showResult && !isEnabled)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(
      duration: 300.ms,
      delay: Duration(milliseconds: index * 100),
    ).slideX(
      begin: 0.2,
      end: 0,
      duration: 400.ms,
      delay: Duration(milliseconds: index * 100),
    );
  }
}

// Compact answer button for smaller screens
class CompactAnswerButton extends StatelessWidget {
  final String text;
  final int index;
  final Color color;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool showResult;
  final bool isCorrect;

  const CompactAnswerButton({
    super.key,
    required this.text,
    required this.index,
    required this.color,
    required this.onPressed,
    this.isSelected = false,
    this.showResult = false,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode(65 + index);
    
    Color getButtonColor() {
      if (showResult) {
        if (isCorrect) return AppColors.mintGreen;
        if (isSelected && !isCorrect) return AppColors.errorRed;
      }
      return color;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: getButtonColor(),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
                maxLines: 2,
              ),
            ),
            if (showResult && (isCorrect || (isSelected && !isCorrect)))
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Animated answer button with loading state
class AnimatedAnswerButton extends StatefulWidget {
  final String text;
  final int index;
  final Color color;
  final Future<bool> Function() onPressed;
  final bool isSelected;
  final bool showResult;
  final bool isCorrect;

  const AnimatedAnswerButton({
    super.key,
    required this.text,
    required this.index,
    required this.color,
    required this.onPressed,
    this.isSelected = false,
    this.showResult = false,
    this.isCorrect = false,
  });

  @override
  State<AnimatedAnswerButton> createState() => _AnimatedAnswerButtonState();
}

class _AnimatedAnswerButtonState extends State<AnimatedAnswerButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await widget.onPressed();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnswerButton(
      text: widget.text,
      index: widget.index,
      color: widget.color,
      onPressed: _handlePress,
      isSelected: widget.isSelected,
      showResult: widget.showResult,
      isCorrect: widget.isCorrect,
      isEnabled: !_isLoading,
    );
  }
}