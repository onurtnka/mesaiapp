import 'dart:async'; // StreamSubscription için gerekli
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/app_database.dart';

// ==============================================================================
// MESAİ HESAPLAMA EKRANI (CANLI VERİTABANI DİNLEYİCİLİ)
// ==============================================================================

class MesaiHesaplamaScreen extends StatefulWidget {
  const MesaiHesaplamaScreen({super.key});

  @override
  State<MesaiHesaplamaScreen> createState() => _MesaiHesaplamaScreenState();
}

class _MesaiHesaplamaScreenState extends State<MesaiHesaplamaScreen> {
  late AppDatabase db;
  StreamSubscription? _salarySubscription; // 🔥 Canlı Takipçi

  // --- MANTIK DEĞİŞKENLERİ ---
  double hourlyNet = 0;
  double hourlyBrut = 0;
  bool _loadingSalary = true;

  double weekdayFactor = 1.5;
  double weekendFactor = 1.5;
  double holidayFactor = 2.0;

  late TextEditingController _weekdayFactorCtrl;
  late TextEditingController _weekendFactorCtrl;
  late TextEditingController _holidayFactorCtrl;

  late TextEditingController _weekdayHoursCtrl;
  late TextEditingController _weekendHoursCtrl;
  late TextEditingController _holidayHoursCtrl;

  double weekdayBrutTotal = 0;
  double weekendBrutTotal = 0;
  double holidayBrutTotal = 0;

  double weekdayNetTotal = 0;
  double weekendNetTotal = 0;
  double holidayNetTotal = 0;

  double get totalBrut => weekdayBrutTotal + weekendBrutTotal + holidayBrutTotal;
  double get totalNet => weekdayNetTotal + weekendNetTotal + holidayNetTotal;

  @override
  void initState() {
    super.initState();
    db = context.read<AppDatabase>();

    _weekdayFactorCtrl = TextEditingController(text: weekdayFactor.toString());
    _weekendFactorCtrl = TextEditingController(text: weekendFactor.toString());
    _holidayFactorCtrl = TextEditingController(text: holidayFactor.toString());

    _weekdayHoursCtrl = TextEditingController(text: "");
    _weekendHoursCtrl = TextEditingController(text: "");
    _holidayHoursCtrl = TextEditingController(text: "");

    _listenToSalaryChanges(); // 🔥 Dinlemeyi başlat
  }

  // 🔥 YENİ FONKSİYON: Veritabanını Canlı Dinler
  void _listenToSalaryChanges() {
    // watch() komutu veritabanındaki her değişikliği anlık bildirir
    _salarySubscription = db.select(db.userSalaryTable).watch().listen((data) {
      if (mounted) {
        setState(() {
          if (data.isNotEmpty) {
            // En son eklenen maaş kaydını al
            final s = data.last; 
            hourlyNet = s.hourlyRateNet ?? 0;
            hourlyBrut = s.hourlyRateBrut ?? 0;
          } else {
            hourlyNet = 0;
            hourlyBrut = 0;
          }
          _loadingSalary = false;
        });
        // Yeni ücret bilgisiyle hesaplamayı hemen güncelle
        _recalculate();
      }
    });
  }

  @override
  void dispose() {
    _salarySubscription?.cancel(); // 🔥 Çıkarken dinlemeyi durdur
    _weekdayFactorCtrl.dispose();
    _weekendFactorCtrl.dispose();
    _holidayFactorCtrl.dispose();
    _weekdayHoursCtrl.dispose();
    _weekendHoursCtrl.dispose();
    _holidayHoursCtrl.dispose();
    super.dispose();
  }

  double _parse(String text, {double fallback = 0}) {
    if (text.trim().isEmpty) return fallback;
    return double.tryParse(text.replaceAll(',', '.')) ?? fallback;
  }

  void _recalculate() {
    setState(() {
      weekdayFactor = _parse(_weekdayFactorCtrl.text, fallback: 0);
      weekendFactor = _parse(_weekendFactorCtrl.text, fallback: 0);
      holidayFactor = _parse(_holidayFactorCtrl.text, fallback: 0);

      final weekdayHours = _parse(_weekdayHoursCtrl.text);
      final weekendHours = _parse(_weekendHoursCtrl.text);
      final holidayHours = _parse(_holidayHoursCtrl.text);

      weekdayBrutTotal = (hourlyBrut * weekdayFactor) * weekdayHours;
      weekendBrutTotal = (hourlyBrut * weekendFactor) * weekendHours;
      holidayBrutTotal = (hourlyBrut * holidayFactor) * holidayHours;

      weekdayNetTotal = (hourlyNet * weekdayFactor) * weekdayHours;
      weekendNetTotal = (hourlyNet * weekendFactor) * weekendHours;
      holidayNetTotal = (hourlyNet * holidayFactor) * holidayHours;
    });
  }

  String _fmt(double v) => NumberFormat("#,##0.00", "tr_TR").format(v);

  // ===========================================================================
  // UI BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    // --- TEMADAN GELEN RENKLER (OTOMATİK UYUM) ---
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final colBg = isDark ? const Color(0xFF111827) : const Color(0xFFF0F2F5);
    final colCard = isDark ? const Color(0xFF1F2937) : Colors.white;
    final colTextMain = isDark ? const Color(0xFFF3F4F6) : const Color(0xFF334155);
    final colTextSec = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);
    final colPrimary = isDark ? const Color(0xFF60A5FA) : const Color(0xFF0F172A);
    final colAccent = const Color(0xFF10B981); // Yeşil (Sabit)
    
    final colInputBg = isDark ? const Color(0xFF374151) : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: colBg,
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Mesai Hesapla", 
            style: TextStyle(color: colTextMain, fontWeight: FontWeight.w800, fontSize: 22)
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: _loadingSalary
            ? Center(child: CircularProgressIndicator(color: colAccent))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHourlyInfoCard(isDark, colAccent),
                    const SizedBox(height: 24),
                    if (hourlyNet == 0) 
                      _buildWarningCard(isDark) 
                    else ...[
                      _buildCalculationInputs(isDark, colCard, colTextMain, colTextSec, colInputBg, colPrimary),
                      const SizedBox(height: 24),
                      _buildResultSection(isDark, colCard, colTextMain, colAccent),
                      const SizedBox(height: 110),
                    ]
                  ],
                ),
              ),
      ),
    );
  }

  // --- 1. ÜST BİLGİ KARTI ---
  Widget _buildHourlyInfoCard(bool isDark, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A), 
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A)).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_filled_rounded, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text("SAATLİK ÜCRET BİLGİSİ", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Net Saatlik", style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text("${_fmt(hourlyNet)} ₺", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Brüt Saatlik", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text("${_fmt(hourlyBrut)} ₺", style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- 2. HESAPLAMA GİRİŞLERİ ---
  Widget _buildCalculationInputs(bool isDark, Color cardColor, Color textMain, Color textSec, Color inputBg, Color primary) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mesai Girişleri", style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text("Çarpan oranlarını ve çalışma saatlerini giriniz.", style: TextStyle(color: textSec, fontSize: 12)),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(flex: 4, child: Text("MESAI TÜRÜ", style: TextStyle(fontSize: 10, color: textSec, fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Center(child: Text("KATSAYI", style: TextStyle(fontSize: 10, color: textSec, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: Center(child: Text("SAAT", style: TextStyle(fontSize: 10, color: textSec, fontWeight: FontWeight.bold)))),
            ],
          ),
          Divider(height: 20, color: isDark ? Colors.white10 : Colors.grey.shade200),
          
          _buildInputRow("Hafta İçi", _weekdayFactorCtrl, _weekdayHoursCtrl, Colors.blue, isDark, textMain, inputBg, primary, textSec),
          const SizedBox(height: 12),
          _buildInputRow("Hafta Sonu", _weekendFactorCtrl, _weekendHoursCtrl, Colors.orange, isDark, textMain, inputBg, primary, textSec),
          const SizedBox(height: 12),
          _buildInputRow("Resmî Tatil", _holidayFactorCtrl, _holidayHoursCtrl, Colors.red, isDark, textMain, inputBg, primary, textSec),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController factorCtrl, TextEditingController hoursCtrl, Color dotColor, bool isDark, Color textMain, Color inputBg, Color primary, Color textSec) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: dotColor.withOpacity(0.5), blurRadius: 4)]),
                ),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: textMain, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildTextField(factorCtrl, false, isDark, inputBg, primary, textMain, textSec),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildTextField(hoursCtrl, true, isDark, inputBg, primary, textMain, textSec),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, bool isPrimary, bool isDark, Color inputBg, Color primary, Color textMain, Color textSec) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrimary 
              ? (isDark ? primary.withOpacity(0.5) : primary.withOpacity(0.2)) 
              : (isDark ? Colors.white12 : Colors.grey.shade300)
        ),
      ),
      child: TextField(
        controller: ctrl,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontWeight: FontWeight.bold, color: isPrimary ? primary : textMain, fontSize: 14),
        cursorColor: primary,
        decoration: InputDecoration(
          border: InputBorder.none, 
          hintText: "0",
          hintStyle: TextStyle(color: textSec.withOpacity(0.5)),
          contentPadding: const EdgeInsets.only(bottom: 8)
        ),
        onChanged: (_) => _recalculate(),
      ),
    );
  }

  // --- 3. SONUÇ BÖLÜMÜ ---
  Widget _buildResultSection(bool isDark, Color cardColor, Color textMain, Color accent) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSummaryBox("Toplam Brüt", totalBrut, textMain, cardColor, isDark)),
            const SizedBox(width: 12),
            Expanded(child: _buildSummaryBox("Toplam Net", totalNet, Colors.white, accent, isDark)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.orange.shade900.withOpacity(0.2) : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.orange.shade900.withOpacity(0.5) : Colors.orange.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: isDark ? Colors.orange.shade200 : Colors.orange.shade800, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text("Net tutar maaş hesabınıza eklenecek tahmini ek ödemedir.", style: TextStyle(color: isDark ? Colors.orange.shade100 : Colors.brown, fontSize: 12))),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSummaryBox(String title, double value, Color textColor, Color bgColor, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          CountingText(
            value: value,
            style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w900),
            suffix: " ₺",
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.amber.shade900.withOpacity(0.2) : Colors.amber.shade50, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.amber.shade800 : Colors.amber.shade200)
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, size: 40, color: isDark ? Colors.amber.shade400 : Colors.amber.shade800),
          const SizedBox(height: 10),
          Text("Saatlik Ücret Bulunamadı", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.amber.shade200 : Colors.amber.shade900)),
          const SizedBox(height: 5),
          Text("Lütfen önce Maaş Hesaplama ekranından bir hesap yapıp kaydedin.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: isDark ? Colors.amber.shade100 : Colors.amber.shade900)),
        ],
      ),
    );
  }
}

// ==============================================================================
// SAYAÇ ANIMASYONU
// ==============================================================================
class CountingText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const CountingText({super.key, required this.value, this.style, this.prefix = "", this.suffix = ""});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, val, child) {
        final fmt = NumberFormat("#,##0.00", "tr_TR").format(val);
        return Text("$prefix$fmt$suffix", style: style);
      },
    );
  }
}