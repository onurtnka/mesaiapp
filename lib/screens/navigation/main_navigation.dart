import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

// 🔥 EKRANLAR
import '../../modules/salary/salary_calculator_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';
import '../mesai/mesai_hesaplama_screen.dart';

class MainNavigation extends StatefulWidget {
  final void Function(bool) onThemeChanged;

  const MainNavigation({super.key, required this.onThemeChanged});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _anim;
  
  // Sayfaları state koruyarak tutmak için
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    // Liquid Animasyon Kontrolcüsü
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 500), 
    );
    
    // Yumuşak yaylanma efekti
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    
    // Başlangıçta animasyon tamamlanmış olsun (İlk ikon yukarıda)
    _controller.value = 1; 

    _pages = [
      const HomeScreen(),
      const SalaryCalculatorScreen(),
      const MesaiHesaplamaScreen(),
      SettingsScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex == index) return;
    
    HapticFeedback.lightImpact(); // Titreşim hissi
    setState(() => _currentIndex = index);
    
    // Animasyonu sıfırla ve yeniden başlat (Sıvı hareketi)
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Renk Paleti (Liquid için özel)
    final bgColor = isDark ? const Color(0xFF111827) : const Color(0xFFF4F6F9);
    final navBarColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final iconSelectedColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0F172A);
    final iconUnselectedColor = isDark ? Colors.grey.shade600 : Colors.grey.shade400;

    return Scaffold(
      backgroundColor: bgColor,
      // Stack ile içeriğin üzerine barı çiziyoruz
      body: Stack(
        children: [
          // 1. SAYFALAR (Arka Plan)
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),

          // 2. LIQUID NAVIGATION BAR (En Altta)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100, // Bar yüksekliği (Kavis payı + güvenli alan)
              child: CustomPaint(
                painter: _LiquidPainter(
                  selectedIndex: _currentIndex,
                  itemCount: 4,
                  color: navBarColor,
                  isDark: isDark,
                ),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLiquidIcon(0, LucideIcons.home, iconSelectedColor, iconUnselectedColor),
                      _buildLiquidIcon(1, LucideIcons.calculator, iconSelectedColor, iconUnselectedColor),
                      _buildLiquidIcon(2, LucideIcons.clock, iconSelectedColor, iconUnselectedColor),
                      _buildLiquidIcon(3, LucideIcons.settings, iconSelectedColor, iconUnselectedColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidIcon(int index, IconData icon, Color activeColor, Color inactiveColor) {
    final isSelected = index == _currentIndex;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(index),
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            // Seçili ikon yukarı çıkar (Floating effect)
            // Animasyon 0'dan 1'e giderken Y değeri -35'e (yukarı) kayar
            double offsetY = isSelected ? -30 * _anim.value : 0;
            
            // Seçili ikon hafif büyür
            double scale = isSelected ? 1.1 : 1.0;

            return Transform.translate(
              offset: Offset(0, offsetY + 15), // +15 hizalama için
              child: Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon, 
                      color: isSelected ? activeColor : inactiveColor,
                      size: 26,
                    ),
                    // Liquid tasarımda genelde yazı olmaz, ikon hareketi yeterlidir
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==============================================================================
// CUSTOM PAINTER: SIVI EFEKTİNİ ÇİZEN MOTOR
// ==============================================================================
class _LiquidPainter extends CustomPainter {
  final int selectedIndex;
  final int itemCount;
  final Color color;
  final bool isDark;

  _LiquidPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Hafif gölge efekti (Derinlik katar)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(isDark ? 0.3 : 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();
    final double itemWidth = size.width / itemCount;
    
    // Çukurun merkezi (Seçili ikonun olduğu yer)
    double centerX = (selectedIndex * itemWidth) + (itemWidth / 2);

    // --- KAVİS AYARLARI (Yumuşatılmış) ---
    double topY = 30;       // Barın üst çizgisinin başladığı Y
    double curveDepth = 35; // Çukurun derinliği
    double curveWidth = 70; // Çukurun genişliği (Yayvan U)

    path.moveTo(0, topY); 
    
    // 1. Sol Düz Çizgi
    path.lineTo(centerX - curveWidth, topY);

    // 2. Kavis (Cubic Bezier - Sıvı Hareketi)
    path.cubicTo(
      centerX - (curveWidth * 0.5), topY,        // Kontrol 1: Giriş
      centerX - (curveWidth * 0.4), topY + curveDepth, // Kontrol 2: İniş
      centerX, topY + curveDepth,                // Hedef: Dip
    );
    
    path.cubicTo(
      centerX + (curveWidth * 0.4), topY + curveDepth, // Kontrol 3: Çıkış
      centerX + (curveWidth * 0.5), topY,        // Kontrol 4: Bitiş
      centerX + curveWidth, topY                 // Sağ Düz
    );

    // 3. Sağ Düz Çizgi
    path.lineTo(size.width, topY);
    
    // 4. Alt ve Yanları Kapat
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Çizim (Önce gölge, sonra bar)
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) {
    // Seçim değişirse veya tema değişirse yeniden çiz
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.color != color;
  }
}