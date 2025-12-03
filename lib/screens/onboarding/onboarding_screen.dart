import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../core/app_database.dart';
import '../../data/tables/user_settings_table.dart';
import '../navigation/main_navigation.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late AppDatabase db;
  int step = 1;
  final data = OnboardingData();

  // Controllers
  final TextEditingController _salaryCtrl = TextEditingController();
  final TextEditingController _monthlyHourCtrl = TextEditingController(text: "225");
  final TextEditingController _wkCtrl = TextEditingController(text: "1.5");
  final TextEditingController _wkdCtrl = TextEditingController(text: "1.5");
  final TextEditingController _holCtrl = TextEditingController(text: "2.0");

  @override
  void initState() {
    super.initState();
    db = context.read<AppDatabase>();
  }

  @override
  void dispose() {
    _salaryCtrl.dispose();
    _monthlyHourCtrl.dispose();
    _wkCtrl.dispose();
    _wkdCtrl.dispose();
    _holCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_salaryCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen maaş bilgisini giriniz")),
      );
      return;
    }

    data.salaryAmount = _salaryCtrl.text;
    data.monthlyWorkHours = _monthlyHourCtrl.text;
    data.overtimeWeekday = _wkCtrl.text;
    data.overtimeWeekend = _wkdCtrl.text;
    data.overtimeHoliday = _holCtrl.text;

    try {
      // 1. Eski ayarları temizle
      await db.delete(db.userSettingsTable).go();
      
      // 2. Yeni ayarları kaydet
      await db.into(db.userSettingsTable).insert(
        UserSettingsTableCompanion.insert(
          weeklyHours: Value(data.weeklyHours),
          monthlyWorkHours: Value(int.tryParse(data.monthlyWorkHours) ?? 225),
          salaryType: Value(data.salaryType),
          salaryAmount: Value(data.salaryAmount),
          overtimeWeekday: Value(data.overtimeWeekday),
          overtimeWeekend: Value(data.overtimeWeekend),
          overtimeNight: Value(data.overtimeHoliday), // DB'de night diye geçiyorsa
          workType: const Value("monthly"), // Varsayılan
          theme: const Value("system"), // Varsayılan
        ),
      );

      // 3. Ana Sayfaya Yönlendir
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainNavigation(onThemeChanged: (v) {}),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint("Kayıt hatası: $e");
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hata oluştu: $e")),
         );
      }
    }
  }

  void _next() {
    if (step < 3) setState(() => step++);
  }

  void _back() {
    if (step > 1) setState(() => step--);
  }

  // --- RENKLER ---
  final Color _colPrimary = const Color(0xFF0F172A); // Koyu Lacivert
  final Color _colAccent = const Color(0xFF3B82F6);  // Mavi
  final Color _colBg = const Color(0xFFF8FAFC);      // Açık Gri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO & BAŞLIK
                Icon(LucideIcons.rocket, size: 48, color: _colAccent),
                const SizedBox(height: 16),
                Text(
                  "Hızlı Kurulum",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _colPrimary),
                ),
                Text(
                  "Sadece 3 adımda hesabını yapalım.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
                
                const SizedBox(height: 30),

                // ADIM GÖSTERGESİ
                _buildProgressBar(),
                
                const SizedBox(height: 30),

                // KART İÇERİĞİ
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
                  child: _buildCurrentStep(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (step) {
      case 1: return _step1Hours();
      case 2: return _step2Salary();
      case 3: return _step3Overtime();
      default: return Container();
    }
  }

  // --- ADIM 1: SAATLER ---
  Widget _step1Hours() {
    return _contentCard(
      key: const ValueKey(1),
      title: "Çalışma Saatleri",
      children: [
        _label("Haftalık Çalışma Saati"),
        Row(
          children: [
            _choiceBtn("40", data.weeklyHours == "40"),
            const SizedBox(width: 10),
            _choiceBtn("45", data.weeklyHours == "45"),
            const SizedBox(width: 10),
            _choiceBtn("Özel", data.weeklyHours != "40" && data.weeklyHours != "45"),
          ],
        ),
        const SizedBox(height: 20),
        _label("Aylık Çalışma Saati"),
        _inputField(controller: _monthlyHourCtrl, hint: "Örn: 225", icon: LucideIcons.clock),
        const SizedBox(height: 24),
        _navButtons(onNext: _next),
      ],
    );
  }

  // --- ADIM 2: MAAŞ ---
  Widget _step2Salary() {
    return _contentCard(
      key: const ValueKey(2),
      title: "Maaş Bilgisi",
      children: [
        _label("Maaş Türü"),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              _tabBtn("Brüt", data.salaryType == "gross", () => setState(() => data.salaryType = "gross")),
              _tabBtn("Net", data.salaryType == "net", () => setState(() => data.salaryType = "net")),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _label("Tutar"),
        _inputField(controller: _salaryCtrl, hint: "Örn: 30000", icon: LucideIcons.wallet, isCurrency: true),
        const SizedBox(height: 24),
        _navButtons(onNext: _next, onBack: _back),
      ],
    );
  }

  // --- ADIM 3: MESAİ ÇARPANLARI ---
  Widget _step3Overtime() {
    return _contentCard(
      key: const ValueKey(3),
      title: "Mesai Çarpanları",
      children: [
        _label("Hafta İçi"),
        _inputField(controller: _wkCtrl, hint: "1.5", icon: LucideIcons.percent),
        const SizedBox(height: 12),
        _label("Hafta Sonu"),
        _inputField(controller: _wkdCtrl, hint: "1.5", icon: LucideIcons.percent),
        const SizedBox(height: 12),
        _label("Resmi Tatil"),
        _inputField(controller: _holCtrl, hint: "2.0", icon: LucideIcons.percent),
        const SizedBox(height: 24),
        _navButtons(onNext: _finish, onBack: _back, isFinish: true),
      ],
    );
  }

  // --- YARDIMCI WIDGETLAR ---

  Widget _contentCard({required Key key, required String title, required List<Widget> children}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _colPrimary)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
    );
  }

  Widget _inputField({required TextEditingController controller, required String hint, required IconData icon, bool isCurrency = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontWeight: FontWeight.bold, color: _colPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
          suffixText: isCurrency ? "₺" : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _choiceBtn(String label, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => data.weeklyHours = label == "Özel" ? "45" : label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _colAccent : Colors.white,
            border: Border.all(color: isSelected ? _colAccent : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _tabBtn(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? _colPrimary : Colors.grey.shade500)),
        ),
      ),
    );
  }

  Widget _navButtons({required VoidCallback onNext, VoidCallback? onBack, bool isFinish = false}) {
    return Row(
      children: [
        if (onBack != null) ...[
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
              child: Icon(LucideIcons.arrowLeft, color: _colPrimary),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: _colPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(isFinish ? "TAMAMLA" : "DEVAM ET", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = step >= index + 1;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 30 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? _colAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}