import 'package:flutter/material.dart';
import 'package:rehab/src/pages/splash_page.dart';
import 'package:rehab/src/theme/app_colors.dart';

class RehabApp extends StatelessWidget {
  const RehabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rehab Sanctuary',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
