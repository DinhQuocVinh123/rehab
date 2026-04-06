import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab/src/pages/home_page.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/decorative_background.dart';
import 'package:rehab/src/widgets/loading_bar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.surfaceBright, AppColors.surfaceLow],
              ),
            ),
          ),
          const DecorativeBackground(),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const GlowCircle(color: AppColors.primaryGlow),
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLowest,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 74, 198, 0.12),
                                    blurRadius: 50,
                                    offset: Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.accessibility_new,
                                size: 80,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          'Rehab Sanctuary',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'CLINICAL EXCELLENCE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.8,
                            color: AppColors.textMuted.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 96,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingBar(
                        controller: _controller,
                        trackColor: AppColors.surfaceHighest,
                        fillColor: AppColors.primary,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 16,
                            color: AppColors.textMuted.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SECURE MEDICAL ENVIRONMENT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: AppColors.textMuted.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
