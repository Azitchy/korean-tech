import 'package:flutter/material.dart';

import 'screens/home_shell.dart';

class ExamApp extends StatelessWidget {
  const ExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFF97316),
      brightness: Brightness.dark,
    );

    ThemeData themeFor(ColorScheme scheme) {
      return ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: scheme.surface.withValues(alpha: 0.95),
          indicatorColor: scheme.primary.withValues(alpha: 0.18),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, height: 1.4),
          bodyMedium: TextStyle(fontSize: 14, height: 1.4),
        ).apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        ),
      );
    }

    return MaterialApp(
      title: 'ExamVerse',
      debugShowCheckedModeBanner: false,
      theme: themeFor(lightScheme),
      darkTheme: themeFor(darkScheme),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}
