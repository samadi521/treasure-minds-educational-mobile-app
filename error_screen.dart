import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class ErrorScreen extends StatefulWidget {
  final String title;
  final String message;
  final String? errorCode;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final IconData? icon;

  const ErrorScreen({
    super.key,
    required this.title,
    required this.message,
    this.errorCode,
    this.onRetry,
    this.onGoHome,
    this.icon,
  });

  // Predefined error screens
  factory ErrorScreen.networkError({VoidCallback? onRetry, VoidCallback? onGoHome}) {
    return ErrorScreen(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ErrorScreen.serverError({VoidCallback? onRetry, VoidCallback? onGoHome}) {
    return ErrorScreen(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      errorCode: '500',
      icon: Icons.cloud_off,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ErrorScreen.notFoundError({VoidCallback? onGoHome}) {
    return ErrorScreen(
      title: 'Page Not Found',
      message: 'The page you\'re looking for doesn\'t exist.',
      errorCode: '404',
      icon: Icons.search_off,
      onGoHome: onGoHome,
    );
  }

  factory ErrorScreen.authError({VoidCallback? onRetry, VoidCallback? onGoHome}) {
    return ErrorScreen(
      title: 'Authentication Failed',
      message: 'Please sign in again to continue.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ErrorScreen.timeoutError({VoidCallback? onRetry}) {
    return ErrorScreen(
      title: 'Request Timeout',
      message: 'The request took too long to complete. Please try again.',
      icon: Icons.timer_off,
      onRetry: onRetry,
    );
  }

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
    _shakeController.forward().then((_) => _shakeController.repeat(reverse: true));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildErrorIcon(),
                const SizedBox(height: 24),
                _buildErrorTitle(),
                const SizedBox(height: 12),
                _buildErrorMessage(),
                if (widget.errorCode != null) ...[
                  const SizedBox(height: 8),
                  _buildErrorCode(),
                ],
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shakeAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.errorRed, AppColors.brightRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorRed.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              widget.icon ?? Icons.error_outline,
              size: 60,
              color: Colors.white,
            ),
          ),
        );
      },
    ).animate().scale(duration: 500.ms).fadeIn();
  }

  Widget _buildErrorTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.errorRed,
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildErrorMessage() {
    return Text(
      widget.message,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildErrorCode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        'Error Code: ${widget.errorCode}',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.errorRed,
          fontFamily: 'monospace',
        ),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (widget.onRetry != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 500.ms),
        if (widget.onRetry != null && widget.onGoHome != null)
          const SizedBox(height: 12),
        if (widget.onGoHome != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: widget.onGoHome,
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.neonPurple,
                side: const BorderSide(color: AppColors.neonPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

// Error boundary widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _handleError();
  }

  void _handleError() {
    try {
      // This is a simplified error boundary
      // In a real app, you'd use FlutterError.onError
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ??
          ErrorScreen(
            title: 'Something Went Wrong',
            message: _errorMessage ?? 'An unexpected error occurred',
            onRetry: () {
              setState(() {
                _hasError = false;
                _handleError();
              });
            },
          );
    }
    return widget.child;
  }
}

// Error toast notification
class ErrorToast {
  static void show(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

// Error dialog
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.errorRed),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: AppColors.errorRed),
          ),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDismiss?.call();
          },
          child: const Text('Dismiss'),
        ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonBlue,
            ),
            child: const Text('Retry'),
          ),
      ],
    );
  }
}

// Connection error widget
class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ConnectionErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.errorRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off,
              size: 50,
              color: AppColors.errorRed,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Empty state widget (not an error but useful)
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );
  }
}
