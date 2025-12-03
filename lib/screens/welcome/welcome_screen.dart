import 'dart:ui'; // Blur efekti için gerekli
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../onboarding/onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  // Animasyon Kontrolcüleri
  late AnimationController _blobController;
  late Animation<double> _blobAnim;
  
  late AnimationController _textController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // 1. Arka Plan Blob Hareketi (Sürekli Dönüş)
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Sonsuz döngü

    // 2. Yazı Giriş Animasyonları
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutQuart),
    );
    
    _fadeAnim = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    // Başlat
    _textController.forward();
  }

  @override
  void dispose() {
    _blobController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
    // Renk Paleti
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final textMain = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSec = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // --- 1. HAREKETLİ ARKA PLAN (AURORA EFEKTİ) ---
          // Mavi Top
          _buildAnimatedBlob(
            color: const Color(0xFF3B82F6).withOpacity(0.4),
            alignment: Alignment.topLeft,
            offset: const Offset(-100, -100),
          ),
          // Mor Top
          _buildAnimatedBlob(
            color: const Color(0xFF8B5CF6).withOpacity(0.4),
            alignment: Alignment.centerRight,
            offset: const Offset(100, -200),
            reverse: true,
          ),
          // Yeşil Top
          _buildAnimatedBlob(
            color: const Color(0xFF10B981).withOpacity(0.3),
            alignment: Alignment.bottomLeft,
            offset: const Offset(-100, 200),
          ),

          // --- 2. BUZLU CAM (BLUR) KATMANI ---
          // Renkleri yumuşatıp "Aurora" etkisi verir
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),

          // --- 3. İÇERİK ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // LOGO
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.barChart3, 
                          size: 50, 
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BAŞLIK VE METİN
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          Text(
                            "Finansal Kontrol",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: textMain,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Maaşınızı, mesailerinizi ve ek gelirlerinizi profesyonelce yönetin. Karmaşık hesaplara son.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: textSec,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ACTION BUTTON
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                          );
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4F46E5).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Hemen Başla",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(LucideIcons.arrowRight, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hareket eden renkli top widget'ı
  Widget _buildAnimatedBlob({
    required Color color, 
    required Alignment alignment, 
    required Offset offset,
    bool reverse = false,
  }) {
    return AnimatedBuilder(
      animation: _blobController,
      builder: (context, child) {
        // Dairesel hareket hesabı
        final double t = _blobController.value * 2 * 3.14159; // 0 -> 2PI
        final double moveX = 30 * (reverse ? -1 : 1) * (0.5 + 0.5 * (t).abs()); // Basit salınım
        final double moveY = 30 * (reverse ? 1 : -1) * (0.5 + 0.5 * (t + 1).abs());

        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset + Offset(moveX, moveY),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}