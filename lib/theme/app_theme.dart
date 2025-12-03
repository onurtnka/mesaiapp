import 'package:flutter/material.dart';

class AppTheme {
  // --- RENKLER ---
  static const Color _lightBg = Color(0xFFF4F6F9); // Açık Gri/Mavi
  static const Color _darkBg = Color(0xFF111827);  // Koyu Lacivert (Slate 900)
  
  static const Color _primaryLight = Color(0xFF0F172A); // Koyu Lacivert
  static const Color _primaryDark = Color(0xFF3B82F6);  // Parlak Mavi
  
  static const Color _accent = Color(0xFF10B981); // Yeşil (Money Green)

  // --- ORTAK GEÇİŞ ANİMASYONU ---
  static const PageTransitionsTheme _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  // --- AYDINLIK TEMA ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBg,
    primaryColor: _primaryLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryLight,
      secondary: _accent,
      surface: Colors.white,
      background: _lightBg,
    ),
    fontFamily: 'Roboto', 
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: _primaryLight),
    ),
    // Sorun çıkaran cardTheme kaldırıldı (Widget'lar kendi stilini yönetiyor)
    pageTransitionsTheme: _pageTransitions,
  );

  // --- KARANLIK TEMA ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBg,
    primaryColor: _primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryDark,
      secondary: _accent,
      surface: Color(0xFF1F2937), // Slate 800
      background: _darkBg,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    // Sorun çıkaran cardTheme kaldırıldı
    pageTransitionsTheme: _pageTransitions,
  );
}