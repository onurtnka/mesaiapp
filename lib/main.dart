import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tarih formatı için

// Dosya yolları
import 'core/app_database.dart';
import 'screens/navigation/main_navigation.dart';
import 'screens/welcome/welcome_screen.dart';
import 'theme/app_theme.dart'; // Tema dosyasını aşağıda oluşturacağız

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Türkçe tarih formatını başlat
  await initializeDateFormatting('tr_TR', null);

  // 2. Veritabanını başlat
  final db = AppDatabase();

  // 3. Kritik verileri PARALEL (Aynı anda) yükle (Performans için)
  final results = await Future.wait([
    _checkOnboarding(db),            // index 0: Onboarding durumu
    SharedPreferences.getInstance(), // index 1: Ayarlar
  ]);

  final bool onboardingCompleted = results[0] as bool;
  final SharedPreferences prefs = results[1] as SharedPreferences;
  final bool isDark = prefs.getBool("darkMode") ?? false;

  runApp(
    Provider<AppDatabase>.value(
      value: db,
      child: MesaiApp(
        onboardingCompleted: onboardingCompleted,
        initialDarkMode: isDark,
      ),
    ),
  );
}

/// Kullanıcının daha önce kurulum yapıp yapmadığını kontrol eder
Future<bool> _checkOnboarding(AppDatabase db) async {
  try {
    final settings = await db.select(db.userSettingsTable).get();
    return settings.isNotEmpty;
  } catch (e) {
    debugPrint("DB Kontrol Hatası: $e");
    return false; // Hata varsa onboarding'e yönlendir
  }
}

class MesaiApp extends StatefulWidget {
  final bool onboardingCompleted;
  final bool initialDarkMode;

  const MesaiApp({
    super.key,
    required this.onboardingCompleted,
    required this.initialDarkMode,
  });

  @override
  State<MesaiApp> createState() => _MesaiAppState();
}

class _MesaiAppState extends State<MesaiApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
  }

  // Temayı değiştiren ve kaydeden fonksiyon
  void updateTheme(bool dark) async {
    setState(() => isDarkMode = dark); // UI'ı anında güncelle
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", dark); // Kalıcı hafızaya yaz
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesai Hesapla',
      debugShowCheckedModeBanner: false,
      
      // Tema Ayarları (AppTheme sınıfından gelir)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Yönlendirme Mantığı
      home: widget.onboardingCompleted
          ? MainNavigation(onThemeChanged: updateTheme) 
          : const WelcomeScreen(),
    );
  }
}