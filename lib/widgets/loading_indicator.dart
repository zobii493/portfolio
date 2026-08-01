import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  final String message;

  const LoadingScreen({super.key, this.message = "Getting things ready"});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final t = _pulseController.value;
                final scale = 1.0 + (t * 0.04);
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SpinKitSpinningLines(
                  color: AppColors.primary,
                  lineWidth: 2.2,
                  size: 56,
                  duration: const Duration(milliseconds: 1400),
                ),
              ),
            ),

            const SizedBox(height: 28),
            Text(
              widget.message,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
