import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;
  final int maxSeconds;
  final bool isActive;
  final double size;
  final double strokeWidth;
  final VoidCallback? onTimeout;

  const TimerWidget({
    super.key,
    required this.seconds,
    required this.maxSeconds,
    this.isActive = true,
    this.size = 80,
    this.strokeWidth = 6,
    this.onTimeout,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = seconds / maxSeconds;
    final timerColor = _getTimerColor(percentage);
    final isWarning = percentage < 0.3;
    final isCritical = percentage < 0.15;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: timerColor.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            ),
          ),
          // Time text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  seconds.toString(),
                  key: ValueKey(seconds),
                  style: TextStyle(
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                    color: timerColor,
                  ),
                ),
              ),
              const Text(
                "sec",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          // Warning pulse animation
          if (isWarning && isActive)
            _buildPulseAnimation(timerColor, size),
          // Critical shake animation
          if (isCritical && isActive)
            _buildShakeAnimation(timerColor, size),
        ],
      ),
    ).animate(
      onPlay: (controller) {
        if (seconds == 0 && onTimeout != null) {
          onTimeout!();
        }
      },
    );
  }

  Widget _buildPulseAnimation(Color color, double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 1.2),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Container(
          width: size * value,
          height: size * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 10 * (value - 0.8),
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShakeAnimation(Color color, double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: -0.05, end: 0.05),
      duration: const Duration(milliseconds: 100),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 0.2,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
        );
      },
    );
  }

  Color _getTimerColor(double percentage) {
    if (percentage < 0.15) {
      return AppColors.errorRed;
    } else if (percentage < 0.3) {
      return AppColors.warningOrange;
    } else {
      return AppColors.mintGreen;
    }
  }
}

// Horizontal timer bar
class TimerBar extends StatelessWidget {
  final int seconds;
  final int maxSeconds;
  final bool isActive;
  final double height;

  const TimerBar({
    super.key,
    required this.seconds,
    required this.maxSeconds,
    this.isActive = true,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = seconds / maxSeconds;
    final timerColor = _getTimerColor(percentage);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: percentage.clamp(0.0, 1.0),
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation<Color>(timerColor),
        minHeight: height,
      ),
    );
  }

  Color _getTimerColor(double percentage) {
    if (percentage < 0.15) return AppColors.errorRed;
    if (percentage < 0.3) return AppColors.warningOrange;
    return AppColors.mintGreen;
  }
}

// Countdown timer with text
class CountdownTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onComplete;
  final VoidCallback? onTick;
  final TextStyle? textStyle;
  final bool autoStart;

  const CountdownTimer({
    super.key,
    required this.initialSeconds,
    this.onComplete,
    this.onTick,
    this.textStyle,
    this.autoStart = true,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _secondsRemaining;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
    _isActive = widget.autoStart;
    if (_isActive) {
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isActive && _secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          widget.onTick?.call();
        });
        if (_secondsRemaining > 0) {
          _startTimer();
        } else {
          widget.onComplete?.call();
        }
      }
    });
  }

  void start() {
    if (!_isActive) {
      setState(() {
        _isActive = true;
      });
      _startTimer();
    }
  }

  void pause() {
    setState(() {
      _isActive = false;
    });
  }

  void reset() {
    setState(() {
      _secondsRemaining = widget.initialSeconds;
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_secondsRemaining),
      style: widget.textStyle ??
          const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.neonBlue,
          ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

// Animated timer circle with pulse effect
class AnimatedTimerCircle extends StatelessWidget {
  final int seconds;
  final int maxSeconds;
  final double size;

  const AnimatedTimerCircle({
    super.key,
    required this.seconds,
    required this.maxSeconds,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = seconds / maxSeconds;
    final timerColor = percentage < 0.3 ? AppColors.errorRed : AppColors.neonBlue;
    
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: percentage),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(timerColor),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    seconds.toString(),
                    style: TextStyle(
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.bold,
                      color: timerColor,
                    ),
                  ),
                  const Text('seconds', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Timer preset buttons
class TimerPresetButtons extends StatelessWidget {
  final int selectedSeconds;
  final ValueChanged<int> onSelected;
  final List<int> presets;

  const TimerPresetButtons({
    super.key,
    required this.selectedSeconds,
    required this.onSelected,
    this.presets = const [15, 30, 45, 60],
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: presets.map((seconds) {
        final isSelected = selectedSeconds == seconds;
        return GestureDetector(
          onTap: () => onSelected(seconds),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.neonBlue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '${seconds}s',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}