import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation/main_navigation.dart';
import '../../main.dart'; 

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

// 🔥 DÜZELTME: 'SingleTickerProviderStateMixin' yerine 'TickerProviderStateMixin'
class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _blobController;
  late AnimationController _textController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); 

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutQuart),
    );
    
    _fadeAnim = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    _textController.forward();
  }

  @override
  void dispose() {
    _blobController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _completeWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(onThemeChanged: (mode) {
             MesaiApp.of(context)?.updateTheme(mode);
          }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final textMain = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSec = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          _buildAnimatedBlob(
            color: const Color(0xFF3B82F6).withOpacity(0.4),
            alignment: Alignment.topLeft,
            offset: const Offset(-100, -100),
          ),
          _buildAnimatedBlob(
            color: const Color(0xFF8B5CF6).withOpacity(0.4),
            alignment: Alignment.centerRight,
            offset: const Offset(100, -200),
            reverse: true,
          ),
          _buildAnimatedBlob(
            color: const Color(0xFF10B981).withOpacity(0.3),
            alignment: Alignment.bottomLeft,
            offset: const Offset(-100, 200),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

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
                            "Maaşınızı, mesailerinizi ve ek gelirlerinizi profesyonelce yönetin.",
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

                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: GestureDetector(
                        onTap: _completeWelcome,
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

  Widget _buildAnimatedBlob({
    required Color color, 
    required Alignment alignment, 
    required Offset offset,
    bool reverse = false,
  }) {
    return AnimatedBuilder(
      animation: _blobController,
      builder: (context, child) {
        final double t = _blobController.value * 2 * 3.14159; 
        final double moveX = 30 * (reverse ? -1 : 1) * (0.5 + 0.5 * (t).abs());
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