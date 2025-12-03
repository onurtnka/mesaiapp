import 'package:flutter/material.dart';

/// 🔥 1. YANA KAYMA (SLIDE) EFEKTİ (Standart Geçiş)
/// Sayfa sağdan sola doğru yumuşakça kayar.
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  
  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animasyon Eğrisi
            const curve = Curves.easeOutCubic;
            
            // Giriş Animasyonu (Sağdan Sola)
            var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: curve));

            // Çıkış Animasyonu (Mevcut sayfa hafifçe sola kaysın ve kararsın)
            var secondaryTween = Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0))
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: SlideTransition(
                position: secondaryAnimation.drive(secondaryTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400), // Hız
        );
}

/// 🔥 2. AŞAĞIDAN YUKARI (MODAL) EFEKTİ
/// "Ekle" gibi işlemler için popup havası verir.
class FadeModalRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeModalRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeOutExpo;
            
            // Aşağıdan Yukarı + Fade
            var slideTween = Tween(begin: const Offset(0.0, 0.1), end: Offset.zero)
                .chain(CurveTween(curve: curve));
            
            var fadeTween = Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: SlideTransition(
                position: animation.drive(slideTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
          barrierColor: Colors.black.withOpacity(0.5), // Arka planı karart
          opaque: false, // Alttaki sayfayı göster
        );
}