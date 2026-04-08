import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class LoadingScreen extends StatefulWidget {
  final String? message;
  final double? progress;
  final VoidCallback? onCancel;

  const LoadingScreen({
    super.key,
    this.message,
    this.progress,
    this.onCancel,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.onCancel != null,
      onPopInvoked: (didPop) {
        if (widget.onCancel != null && !didPop) {
          widget.onCancel!();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedLoader(),
                const SizedBox(height: 24),
                _buildLoadingMessage(),
                if (widget.progress != null) ...[
                  const SizedBox(height: 16),
                  _buildProgressBar(),
                ],
                if (widget.onCancel != null) ...[
                  const SizedBox(height: 20),
                  _buildCancelButton(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLoader() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.rainbowGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingMessage() {
    return Column(
      children: [
        Text(
          widget.message ?? 'Loading...',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.neonPurple,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 8),
        Text(
          _getRandomTip(),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: widget.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${((widget.progress ?? 0) * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: widget.onCancel,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.errorRed,
        side: const BorderSide(color: AppColors.errorRed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: const Text('Cancel'),
    );
  }

  String _getRandomTip() {
    final List<String> tips = [
      '💡 Did you know? You can change your avatar in settings!',
      '🎮 Complete daily challenges for bonus rewards!',
      '🏆 Maintain your streak to earn special badges!',
      '📚 Practice makes perfect - play daily to improve!',
      '👥 Invite friends to compete on the leaderboard!',
      '⭐ Answer quickly for time bonus points!',
      '🔑 Collect keys to unlock the treasure chest!',
      '🧩 Puzzles help improve critical thinking!',
      '🎯 Aim for 100% accuracy to master subjects!',
      '📈 Track your progress in the analytics section!',
    ];
    return tips[DateTime.now().millisecondsSinceEpoch % tips.length];
  }
}

// Simplified loading overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Skeleton loading screen for content
class SkeletonLoadingScreen extends StatelessWidget {
  const SkeletonLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSkeletonHeader(),
              const SizedBox(height: 20),
              _buildSkeletonCard(),
              const SizedBox(height: 16),
              _buildSkeletonCard(),
              const SizedBox(height: 16),
              _buildSkeletonCard(),
              const SizedBox(height: 16),
              _buildSkeletonGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms);
  }

  Widget _buildSkeletonCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms);
  }

  Widget _buildSkeletonGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: List.generate(4, (index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
      )),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms);
  }
}

// Shimmer effect extension
extension ShimmerExtension on Widget {
  Widget shimmer({Duration duration = const Duration(milliseconds: 1500)}) {
    return ShimmerEffect(
      duration: duration,
      child: this,
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Gradient?> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    final gradient = LinearGradient(
      colors: [
        Colors.grey.shade200,
        Colors.grey.shade100,
        Colors.grey.shade200,
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: const Alignment(-1.0, 0.0),
      end: const Alignment(1.0, 0.0),
    );

    _gradientAnimation = _controller.drive(
      Tween<Gradient?>(
        begin: gradient,
        end: gradient,
      ).chain(CurveTween(curve: Curves.linear)),
    ) as Animation<Gradient?>;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final shader = _gradientAnimation.value?.createShader(bounds) ?? const LinearGradient(colors: []).createShader(bounds);
            return shader;
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

// Full screen loading with animation
class FullScreenLoading extends StatelessWidget {
  final String? message;

  const FullScreenLoading({super.key, this.message});

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                message ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 16),
              Text(
                'Please wait while we prepare your adventure',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// Loading button
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;

  const LoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.neonBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
