import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../config/theme.dart';

class NoInternetScreen extends StatefulWidget {
  final VoidCallback? onRetry;
  final bool autoCheck;

  const NoInternetScreen({
    super.key,
    this.onRetry,
    this.autoCheck = true,
  });

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  Timer? _checkTimer;
  bool _isChecking = false;
  int _checkCount = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _rotationController.repeat();

    if (widget.autoCheck) {
      _startAutoCheck();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _checkTimer?.cancel();
    super.dispose();
  }

  void _startAutoCheck() {
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isChecking && mounted) {
        _checkConnectivity();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    if (_isChecking) return;
    
    setState(() {
      _isChecking = true;
    });

    final ConnectivityResult result = await Connectivity().checkConnectivity();
    final bool hasInternet = result != ConnectivityResult.none;
    
    setState(() {
      _isChecking = false;
      _checkCount++;
    });

    if (hasInternet && mounted) {
      widget.onRetry?.call();
      if (mounted) {
        Navigator.pop(context);
      }
    }
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
                _buildAnimatedIcon(),
                const SizedBox(height: 32),
                _buildTitle(),
                const SizedBox(height: 16),
                _buildMessage(),
                const SizedBox(height: 24),
                _buildTipsSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
                if (_isChecking) ...[
                  const SizedBox(height: 20),
                  _buildCheckingIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
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
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.errorRed, AppColors.warningOrange],
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
                  child: const Icon(
                    Icons.wifi_off,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        );
      },
    ).animate().scale(duration: 500.ms).fadeIn();
  }

  Widget _buildTitle() {
    return Text(
      'No Internet Connection',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.errorRed,
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMessage() {
    return Text(
      'Please check your internet connection and try again.\n'
      'Some features require an active internet connection.',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildTipsSection() {
    final tips = [
      '📱 Check if airplane mode is off',
      '📶 Make sure Wi-Fi or mobile data is enabled',
      '🔄 Toggle airplane mode on/off',
      '🔌 Restart your router',
      '📲 Try using another app to check connection',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(Icons.lightbulb, color: AppColors.gold, size: 20),
              SizedBox(width: 8),
              Text(
                'Quick Fixes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: AppColors.mintGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: _isChecking ? null : _checkConnectivity,
            icon: _isChecking 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text(_isChecking ? 'Checking...' : 'Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.neonPurple,
              side: const BorderSide(color: AppColors.neonPurple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildCheckingIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.neonBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.neonBlue,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Checking connection... (Attempt $_checkCount)',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.neonBlue,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}

// Internet connection status widget
class ConnectionStatusWidget extends StatefulWidget {
  final Widget child;
  final Widget? disconnectedWidget;

  const ConnectionStatusWidget({
    super.key,
    required this.child,
    this.disconnectedWidget,
  });

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final ConnectivityResult? result = snapshot.data;
          final bool hasConnection = result != null && result != ConnectivityResult.none;
          
          if (!hasConnection) {
            return widget.disconnectedWidget ?? _buildOfflineBanner(context);
          }
        }
        return widget.child;
      },
    );
  }

  Widget _buildOfflineBanner(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: const BoxDecoration(
            color: AppColors.errorRed,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'No Internet Connection',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NoInternetScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Fix',
                    style: TextStyle(
                      color: AppColors.errorRed,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

// Internet required wrapper
class InternetRequired extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const InternetRequired({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return ConnectionStatusWidget(
      child: child,
      disconnectedWidget: fallback ?? const NoInternetScreen(),
    );
  }
}

// Offline cache indicator
class OfflineCacheIndicator extends StatelessWidget {
  final int cachedItems;
  final VoidCallback onSync;

  const OfflineCacheIndicator({
    super.key,
    required this.cachedItems,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_queue,
              color: AppColors.warningOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Offline Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '$cachedItems items saved offline',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onSync,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Sync', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
