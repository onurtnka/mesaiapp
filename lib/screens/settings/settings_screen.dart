import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

// Veritabanı ve Tablo Importları
import '../../core/app_database.dart';
import '../../data/tables/user_settings_table.dart';

// Diğer ekranlar
import 'developer_info_screen.dart';
import 'mesai_carpan_screen.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(bool) onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 🔥 DÜZELTME: Yerel '_isDarkMode' değişkeni ve 'initState' kaldırıldı.
  // Tema durumu anlık olarak 'build' metodunda hesaplanacak.

  // --- WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    // 🔥 KRİTİK NOKTA: Switch'in açık/kapalı olduğunu doğrudan temadan anlıyoruz.
    // Böylece açılışta bekleme, parlama veya senkron hatası olmaz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Renk Paleti (Otomatik)
    final colBg = isDark ? const Color(0xFF111827) : const Color(0xFFF4F6F9);
    final colCard = isDark ? const Color(0xFF1F2937) : Colors.white;
    final colTextMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final colTextSec = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final colBorder = isDark ? Colors.white10 : Colors.grey.shade200;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: colBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Ayarlar",
            style: TextStyle(color: colTextMain, fontWeight: FontWeight.w800, fontSize: 24),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Genel Görünüm", colTextSec),
              
              // Tema Kartı
              _buildThemeCard(
                isDark: isDark, // Doğrudan hesaplanan değer
                cardColor: colCard,
                borderColor: colBorder,
                textMain: colTextMain,
                textSec: colTextSec
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader("Maaş & Mesai", colTextSec),
              _buildSettingsCard(
                colCard: colCard,
                colBorder: colBorder,
                isDark: isDark,
                children: [
                  _buildTileItem(
                    title: "Mesai Çarpanları",
                    subtitle: "Hafta içi, hafta sonu katsayıları",
                    icon: LucideIcons.percent,
                    iconColor: Colors.blue,
                    onTap: () => _navTo(const MesaiCarpanScreen()),
                    textMain: colTextMain,
                    textSec: colTextSec,
                  ),
                  _buildDivider(isDark),
                  _buildTileItem(
                    title: "Aylık Çalışma Saati",
                    subtitle: "Varsayılan: 225 Saat",
                    icon: LucideIcons.clock,
                    iconColor: Colors.orange,
                    onTap: () => _updateWorkHours(isDark, colCard, colTextMain, colTextSec),
                    textMain: colTextMain,
                    textSec: colTextSec,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _buildSectionHeader("Uygulama", colTextSec),
              _buildSettingsCard(
                colCard: colCard,
                colBorder: colBorder,
                isDark: isDark,
                children: [
                  _buildTileItem(
                    title: "Premium'a Geç",
                    subtitle: "Reklamsız deneyim ve sınırsız kayıt",
                    icon: LucideIcons.crown,
                    iconColor: const Color(0xFFFFD700),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Premium özelliği yakında!")),
                      );
                    },
                    textMain: colTextMain,
                    textSec: colTextSec,
                  ),
                  _buildDivider(isDark),
                  _buildTileItem(
                    title: "Hakkında & İletişim",
                    subtitle: "Geliştirici bilgileri",
                    icon: LucideIcons.info,
                    iconColor: Colors.purple,
                    onTap: () => _navTo(const DeveloperInfoScreen()),
                    textMain: colTextMain,
                    textSec: colTextSec,
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "Versiyon 1.0.0",
                  style: TextStyle(color: colTextSec, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET YAPILARI ---

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildThemeCard({
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color textMain,
    required Color textSec,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: SwitchListTile(
        value: isDark,
        // Butona basılınca main.dart'taki fonksiyonu çağırıyoruz
        onChanged: (val) => widget.onThemeChanged(val), 
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF6366F1),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        title: Text("Karanlık Mod", style: TextStyle(color: textMain, fontWeight: FontWeight.w700, fontSize: 16)),
        subtitle: Text(isDark ? "Göz yormayan koyu tema" : "Aydınlık tema aktif", style: TextStyle(color: textSec, fontSize: 13)),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.indigo.withOpacity(0.2) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isDark ? LucideIcons.moon : LucideIcons.sun,
            color: isDark ? Colors.indigoAccent : Colors.orange,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children, required Color colCard, required Color colBorder, required bool isDark}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: colCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTileItem({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required Color textMain,
    required Color textSec,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: TextStyle(color: textMain, fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: subtitle != null ? Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle, style: TextStyle(color: textSec, fontSize: 13))) : null,
      trailing: Icon(LucideIcons.chevronRight, color: textSec.withOpacity(0.5), size: 20),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(height: 1, thickness: 1, color: isDark ? Colors.white10 : Colors.grey.shade100, indent: 70);
  }

  void _navTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _updateWorkHours(bool isDark, Color bg, Color textMain, Color textSec) async {
    final controller = TextEditingController();
    int? newValue = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Aylık Çalışma Saati", style: TextStyle(color: textMain)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(color: textMain),
            decoration: InputDecoration(
              hintText: "Örn: 225",
              hintStyle: TextStyle(color: textSec),
              filled: true,
              fillColor: isDark ? const Color(0xFF374151) : Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(child: Text("İptal", style: TextStyle(color: textSec)), onPressed: () => Navigator.pop(context)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0) Navigator.pop(context, value);
              },
            ),
          ],
        );
      },
    );

    if (newValue != null && mounted) {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final settings = await db.select(db.userSettingsTable).get();
      if(settings.isEmpty) {
         await db.into(db.userSettingsTable).insert(UserSettingsTableCompanion(monthlyWorkHours: Value(newValue)));
      } else {
         await (db.update(db.userSettingsTable)..where((t) => t.id.equals(settings.first.id))).write(
            UserSettingsTableCompanion(monthlyWorkHours: Value(newValue)),
         );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Çalışma saati güncellendi"),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}