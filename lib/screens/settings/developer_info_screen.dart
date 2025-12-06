import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart'; // Linkleri açmak için (pubspec'e eklemelisin)

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  // Link açma fonksiyonu
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- TEMA AYARLARI ---
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final colBg = isDark ? const Color(0xFF111827) : const Color(0xFFF4F6F9);
    final colCard = isDark ? const Color(0xFF1F2937) : Colors.white;
    final colTextMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final colTextSec = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final colBorder = isDark ? Colors.white10 : Colors.grey.shade200;
    final colAccent = const Color(0xFF3B82F6); // Mavi

    return Scaffold(
      backgroundColor: colBg,
      appBar: AppBar(
        title: Text(
          "Geliştirici Bilgileri",
          style: TextStyle(color: colTextMain, fontWeight: FontWeight.w800, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colTextMain),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ANA KART
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LOGO / AVATAR
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.code2, size: 40, color: colAccent),
                  ),
                  
                  const SizedBox(height: 16),

                  Text(
                    "Mio Technic",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colTextMain,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    "Mobil Uygulama Çözümleri",
                    style: TextStyle(
                      fontSize: 14,
                      color: colTextSec,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  Text(
                    "Bu uygulama tamamen ücretsiz ve açık kaynaklı olarak geliştirilmiştir. Görüş ve önerilerinizi bekliyoruz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: colTextSec, height: 1.5),
                  ),

                  const SizedBox(height: 32),

                  // İLETİŞİM BUTONLARI
                  _buildContactRow(
                    icon: LucideIcons.mail,
                    label: "destek@miotechnic.com",
                    color: Colors.orange,
                    onTap: () => _launchUrl("mailto:destek@miotechnic.com"),
                    textColor: colTextMain,
                    bgColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildContactRow(
                    icon: LucideIcons.github,
                    label: "github.com/miotechnic",
                    color: isDark ? Colors.white : Colors.black,
                    onTap: () => _launchUrl("https://github.com/miotechnic"),
                    textColor: colTextMain,
                    bgColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                  ),
                  
                  const SizedBox(height: 12),

                  _buildContactRow(
                    icon: LucideIcons.globe,
                    label: "miotechnic.com",
                    color: Colors.blue,
                    onTap: () => _launchUrl("https://miotechnic.com"),
                    textColor: colTextMain,
                    bgColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            Text(
              "v1.0.0 • Build 100",
              style: TextStyle(color: colTextSec.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required Color textColor,
    required Color bgColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                ),
              ),
              Icon(LucideIcons.externalLink, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}