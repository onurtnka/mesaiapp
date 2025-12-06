import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../core/app_database.dart';
import '../../data/tables/user_settings_table.dart';
import 'developer_info_screen.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
          title: Text("Ayarlar", style: TextStyle(color: colTextMain, fontWeight: FontWeight.w800, fontSize: 24)),
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
              
              // TEMA SEÇİCİ
              _buildThemeSelector(isDark, colCard, colBorder, colTextMain, colTextSec),
              
              const SizedBox(height: 24),
              
              _buildSectionHeader("Uygulama", colTextSec),
              
              // UYGULAMA AYARLARI
              _buildSettingsCard(
                colCard: colCard, colBorder: colBorder, isDark: isDark,
                children: [
                  _buildTileItem(
                    title: "Premium'a Geç",
                    subtitle: "Reklamsız deneyim ve sınırsız kayıt",
                    icon: LucideIcons.crown,
                    iconColor: const Color(0xFFFFD700),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Premium özelliği yakında!")));
                    },
                    textMain: colTextMain, textSec: colTextSec,
                  ),
                  _buildDivider(isDark),
                  _buildTileItem(
                    title: "Hakkında & İletişim",
                    subtitle: "Geliştirici bilgileri",
                    icon: LucideIcons.info,
                    iconColor: Colors.purple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeveloperInfoScreen())),
                    textMain: colTextMain, textSec: colTextSec,
                  ),
                  _buildDivider(isDark),
                  // Verileri Sıfırla Butonu (Opsiyonel ama faydalı)
                  _buildTileItem(
                    title: "Verileri Sıfırla",
                    subtitle: "Tüm kayıtları sil",
                    icon: LucideIcons.trash2,
                    iconColor: Colors.redAccent,
                    onTap: () => _resetData(context),
                    textMain: colTextMain, textSec: colTextSec,
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              Center(
                child: Text("Versiyon 1.0.0", style: TextStyle(color: colTextSec, fontSize: 12)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- TEMA SEÇİCİ ---
  Widget _buildThemeSelector(bool isDark, Color cardColor, Color borderColor, Color textMain, Color textSec) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.indigo.withOpacity(0.2) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(isDark ? LucideIcons.moon : LucideIcons.sun, color: isDark ? Colors.indigoAccent : Colors.orange, size: 22),
        ),
        title: Text("Görünüm", style: TextStyle(color: textMain, fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text("Sistem, Açık veya Koyu tema seçin", style: TextStyle(color: textSec, fontSize: 13)),
        trailing: const Icon(LucideIcons.chevronRight, size: 20, color: Colors.grey),
        onTap: () => _showThemeDialog(isDark, cardColor, textMain),
      ),
    );
  }

  void _showThemeDialog(bool isDark, Color bg, Color text) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text("Tema Seçin", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: text)),
              const SizedBox(height: 10),
              _themeOption("Sistem Varsayılanı", ThemeMode.system, LucideIcons.smartphone, text),
              _themeOption("Açık Tema", ThemeMode.light, LucideIcons.sun, text),
              _themeOption("Koyu Tema", ThemeMode.dark, LucideIcons.moon, text),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _themeOption(String label, ThemeMode mode, IconData icon, Color text) {
    return ListTile(
      leading: Icon(icon, color: text.withOpacity(0.7)),
      title: Text(label, style: TextStyle(color: text)),
      onTap: () {
        widget.onThemeChanged(mode);
        Navigator.pop(context);
      },
    );
  }

  // --- YARDIMCI WIDGETLAR ---
  Widget _buildSectionHeader(String title, Color color) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 12), child: Text(title.toUpperCase(), style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)));

  Widget _buildSettingsCard({required List<Widget> children, required Color colCard, required Color colBorder, required bool isDark}) {
    return Container(decoration: BoxDecoration(color: colCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: colBorder), boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 15, offset: const Offset(0, 5))]), child: Column(children: children));
  }

  Widget _buildTileItem({required String title, String? subtitle, required IconData icon, required Color iconColor, required VoidCallback onTap, required Color textMain, required Color textSec}) {
    return ListTile(onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 22)), title: Text(title, style: TextStyle(color: textMain, fontWeight: FontWeight.w600, fontSize: 16)), subtitle: subtitle != null ? Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle, style: TextStyle(color: textSec, fontSize: 13))) : null, trailing: Icon(LucideIcons.chevronRight, color: textSec.withOpacity(0.5), size: 20));
  }

  Widget _buildDivider(bool isDark) => Divider(height: 1, thickness: 1, color: isDark ? Colors.white10 : Colors.grey.shade100, indent: 70);

  // --- VERİ SIFIRLAMA FONKSİYONU ---
  Future<void> _resetData(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Emin misiniz?"),
        content: const Text("Tüm kayıtlarınız kalıcı olarak silinecektir."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("İptal")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("SİL", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirm == true) {
      final db = Provider.of<AppDatabase>(context, listen: false);
      await db.delete(db.mesaiTable).go();
      await db.delete(db.userSalaryTable).go();
      // Ayarları silmiyoruz, sadece verileri
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veriler sıfırlandı.")));
    }
  }
}