import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:drift/drift.dart' as drift;

import 'core/app_database.dart';
import 'screens/navigation/main_navigation.dart';
import 'screens/welcome/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  final db = AppDatabase();
  await _ensureDefaultSettings(db);

  runApp(
    Provider<AppDatabase>(
      create: (_) => db,
      dispose: (_, db) => db.close(),
      child: const MesaiApp(),
    ),
  );
}

Future<void> _ensureDefaultSettings(AppDatabase db) async {
  try {
    final settings = await db.select(db.userSettingsTable).get();

    if (settings.isEmpty) {
      await db.into(db.userSettingsTable).insert(
        const UserSettingsTableCompanion(
          // ✅ weeklyHours String olmalı
          weeklyHours: drift.Value('45'),
          monthlyWorkHours: drift.Value(225),
          workType: drift.Value('monthly'),
        ),
      );
    }
  } catch (e) {
    debugPrint("Varsayılan ayar hatası: $e");
  }
}

class MesaiApp extends StatefulWidget {
  const MesaiApp({super.key});

  static _MesaiAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MesaiAppState>();

  @override
  State<MesaiApp> createState() => _MesaiAppState();
}

class _MesaiAppState extends State<MesaiApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late final Future<bool> _initAppFuture;

  @override
  void initState() {
    super.initState();
    _initAppFuture = _initApp();
  }

  Future<bool> _initApp() async {
    final prefs = await SharedPreferences.getInstance();

    final themeStr = prefs.getString("theme_mode") ?? "system";
    final loadedTheme = _getThemeMode(themeStr);

    if (mounted) {
      setState(() => _themeMode = loadedTheme);
    }

    await Future.delayed(const Duration(seconds: 3));

    return prefs.getBool("onboarding_completed") ?? false;
  }

  Future<void> updateTheme(ThemeMode mode) async {
    if (!mounted) return;

    setState(() => _themeMode = mode);

    final prefs = await SharedPreferences.getInstance();
    String modeStr = 'system';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';

    await prefs.setString("theme_mode", modeStr);
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesai Hesapla',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: FutureBuilder<bool>(
        future: _initAppFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const WelcomeScreen();
          }

          final hasSeenWelcome = snapshot.data ?? false;

          if (hasSeenWelcome) {
            return MainNavigation(onThemeChanged: updateTheme);
          }

          return const WelcomeScreen();
        },
      ),
    );
  }
}
