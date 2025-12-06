import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

// 🔥 EKRANLAR
import '../../modules/salary/salary_calculator_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';
import '../mesai/mesai_hesaplama_screen.dart';

class MainNavigation extends StatefulWidget {
  // 🔥 GÜNCELLEME: Artık ThemeMode alıyor (Sistem/Açık/Koyu)
  final void Function(ThemeMode) onThemeChanged;

  const MainNavigation({super.key, required this.onThemeChanged});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _anim;
  
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    // Liquid Animasyon Kontrolcüsü
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 500), 
    );
    
    // Elastik efekt (Orijinal Liquid hissi)
    _anim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    
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
    
    HapticFeedback.lightImpact(); // Hafif titreşim
    setState(() => _currentIndex = index);
    
    // Animasyonu sıfırla ve yeniden başlat (Sıvı hareketi)
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // --- RENK PALETİ (Liquid İçin Özel) ---
    final bgColor = isDark ? const Color(0xFF111827) : const Color(0xFFF4F6F9);
    final navBarColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    
    // Top (Bubble) rengi - Fintech Mavisi
    final bubbleColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0F172A);
    
    final iconSelectedColor = Colors.white; 
    final iconUnselectedColor = isDark ? Colors.grey.shade600 : Colors.grey.shade400;

    return Scaffold(
      backgroundColor: bgColor,
      extendBody: true, // Barın arkasına içerik kaysın (Liquid için şart)
      
      // 🔥 SAYFA GEÇİŞ ANİMASYONU (YENİ)
      body: SizedBox.expand(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: _pages[_currentIndex],
          ),
        ),
      ),

      // 🔥 LIQUID NAVIGATION BAR (KORUNDU)
      bottomNavigationBar: SizedBox(
        height: 200, // Bar yüksekliği (Kavis payı dahil)
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 1. ÖZEL ÇİZİM BAR (Arka plan ve Oyuk)
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 100),
              painter: _LiquidPainter(
                selectedIndex: _currentIndex,
                itemCount: 4,
                color: navBarColor, // Barın rengi
                isDark: isDark,
              ),
            ),

            // 2. HAREKET EDEN TOP (BUBBLE)
            _buildAnimatedBubble(bubbleColor),

            // 3. İKONLAR
            SizedBox(
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
          ],
        ),
      ),
    );
  }

  // Hareket eden renkli top (Bubble)
  Widget _buildAnimatedBubble(Color color) {
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / 4;
    
    // Topun yatay pozisyonu
    final double leftPos = (_currentIndex * itemWidth) + (itemWidth / 2) - 26; // 25 = yarıçap

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500), // Animasyonla senkron
      curve: Curves.elasticOut, 
      left: leftPos,
      bottom: 40, // Barın üstünde yüzüyor (Oyuğun tam ortasında)
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
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
            // Animasyon 0'dan 1'e giderken Y değeri -30'a (yukarı) kayar
            double offsetY = isSelected ? -30 * _anim.value : 0;
            
            return Transform.translate(
              offset: Offset(0, offsetY + 15), // +15 dikey hizalama
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon, 
                    // Seçiliyse Beyaz, Değilse Gri
                    color: isSelected ? activeColor : inactiveColor,
                    size: 26,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==============================================================================
// CUSTOM PAINTER: SIVI EFEKTİNİ ÇİZEN MOTOR (KORUNDU)
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
      ..color = Colors.black.withOpacity(isDark ? 0.5 : 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    final path = Path();
    final double itemWidth = size.width / itemCount;
    
    // Çukurun merkezi
    double centerX = (selectedIndex * itemWidth) + (itemWidth / 2);

    // --- KAVİS AYARLARI (Yumuşatılmış) ---
    double topY = 25;       // Barın başladığı Y noktası (0 en üst)
    double curveDepth = 45; // Çukurun derinliği
    double curveWidth = 75; // Çukurun genişliği (Yayvanlık)

    path.moveTo(0, topY); 
    
    // 1. Sol Düz Çizgi (Merkeze kadar)
    path.lineTo(centerX - curveWidth, topY);

    // 2. Kavis (Su damlası oyuğu)
    path.cubicTo(
      centerX - (curveWidth * 0.5), topY,        // Kontrol 1
      centerX - (curveWidth * 0.4), topY + curveDepth, // Kontrol 2
      centerX, topY + curveDepth,                // Hedef (Dip)
    );
    
    path.cubicTo(
      centerX + (curveWidth * 0.4), topY + curveDepth, // Kontrol 3
      centerX + (curveWidth * 0.5), topY,        // Kontrol 4
      centerX + curveWidth, topY                 // Sağ Düz
    );

    // 3. Sağ Düz Çizgi ve Kapatma
    path.lineTo(size.width, topY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Çizim (Gölgeyi biraz aşağı kaydırarak çiz)
    canvas.drawPath(path.shift(const Offset(0, -5)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) {
    // Seçim veya renk değişirse yeniden çiz
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.color != color;
  }
}