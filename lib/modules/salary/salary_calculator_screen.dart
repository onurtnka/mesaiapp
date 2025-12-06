import 'dart:convert';
import 'dart:math' as math;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../core/app_database.dart';
import 'salary_calculator_service.dart';
import 'salary_result_model.dart';

class SalaryCalculatorScreen extends StatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  State<SalaryCalculatorScreen> createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> with TickerProviderStateMixin {
  final SalaryCalculatorService _service = SalaryCalculatorService();
  final TextEditingController _masterGrossController = TextEditingController();
  late List<TextEditingController> _monthlyControllers;
  
  List<SalaryResult> _results = [];
  bool _isCalculated = false;
  bool _useMonthlyMode = false;
  bool _isGrossToNet = true; 

  @override
  void initState() {
    super.initState();
    _monthlyControllers = List.generate(12, (index) => TextEditingController());
  }

  @override
  void dispose() {
    _masterGrossController.dispose();
    for(var c in _monthlyControllers) c.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    List<double> inputs = [];

    if (_useMonthlyMode) {
      for (var c in _monthlyControllers) {
        inputs.add(double.tryParse(c.text.replaceAll(',', '.')) ?? 0);
      }
    } else {
      double val = double.tryParse(_masterGrossController.text.replaceAll(',', '.')) ?? 0;
      inputs = List.filled(12, val);
    }

    if (inputs.every((e) => e == 0)) return;

    setState(() {
      _isCalculated = false;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      List<SalaryResult> res;
      if (_isGrossToNet) {
         res = _service.calculateYear(inputs);
      } else {
         res = _service.calculateYearFromNet(inputs);
      }

      setState(() {
        _results = res;
        _isCalculated = true;
      });
    });
  }

  Future<void> _saveToDb() async {
    if (_results.isEmpty) return;
    try {
      final db = context.read<AppDatabase>();
      final last = _results.last;
      
      await db.into(db.userSalaryTable).insert(UserSalaryTableCompanion.insert(
        monthlyBrut: last.brut,
        monthlyNet: last.netEleGecen, // Düzeltildi
        sgkIsci: last.sgkIsci,
        issizlikIsci: last.issizlikIsci,
        sgkIsveren: 0,
        issizlikIsveren: 0,
        damga: last.damgaVergisi,
        gvDilimi: 0,
        kumulatifMatrah: last.kumulatifMatrah, // Düzeltildi
        hourlyRateNet: Value(last.netEleGecen / 225), // Düzeltildi
        hourlyRateBrut: Value(last.brut / 225),
      ));
      
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text("Başarıyla Kaydedildi")]),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("DB Hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colBg = isDark ? const Color(0xFF111827) : const Color(0xFFF0F2F5);
    final colCard = isDark ? const Color(0xFF1F2937) : Colors.white;
    final colTextMain = isDark ? const Color(0xFFF3F4F6) : const Color(0xFF334155);
    final colTextSec = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);
    final colPrimary = isDark ? const Color(0xFF60A5FA) : const Color(0xFF0F172A);
    final colAccent = const Color(0xFF10B981);
    final colInputBg = isDark ? const Color(0xFF374151) : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: colBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Maaş Projeksiyonu", style: TextStyle(color: colTextMain, fontWeight: FontWeight.w800, fontSize: 22)),
          centerTitle: false,
          automaticallyImplyLeading: false, 
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputCard(isDark, colCard, colTextMain, colTextSec, colPrimary, colInputBg),
              const SizedBox(height: 24),
              
              if (_isCalculated) ...[
                 _buildSummaryCards(isDark, colAccent),
                const SizedBox(height: 20),
                _buildResultsList(colTextSec, colCard, colBg, colTextMain),
                const SizedBox(height: 20),
                _buildSaveButton(colPrimary, colAccent),
                const SizedBox(height: 110), 
              ] else 
                _buildEmptyState(colTextSec),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(bool isDark, Color cardColor, Color textMain, Color textSec, Color primary, Color inputBg) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTypeTab("Brütten Nete", _isGrossToNet, () => setState(() => _isGrossToNet = true), primary, isDark),
                _buildTypeTab("Netten Brüte", !_isGrossToNet, () => setState(() => _isGrossToNet = false), primary, isDark),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_isGrossToNet ? "Aylık Brüt Maaş" : "Aylık Net Maaş", style: TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.w700)),
              InkWell(
                onTap: () => setState(() => _useMonthlyMode = !_useMonthlyMode),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _useMonthlyMode ? primary.withOpacity(0.1) : (isDark ? Colors.white10 : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _useMonthlyMode ? primary : Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Text("Her Ay Farklı", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _useMonthlyMode ? primary : textSec)),
                      const SizedBox(width: 6),
                      Icon(_useMonthlyMode ? Icons.check_circle : Icons.circle_outlined, size: 16, color: _useMonthlyMode ? primary : textSec)
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: _buildSingleInput(inputBg, primary, textSec),
            secondChild: _buildMonthlyInputs(inputBg, textMain, textSec),
            crossFadeState: _useMonthlyMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: primary.withOpacity(0.3),
              ),
              child: const Text("HESAPLA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab(String text, bool isSelected, VoidCallback onTap, Color primary, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? Colors.grey.shade800 : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? primary : (isDark ? Colors.grey : Colors.grey.shade600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleInput(Color bg, Color primary, Color hint) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _masterGrossController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: primary),
        decoration: InputDecoration(
          hintText: "Örn: ${_isGrossToNet ? '70000' : '50000'}",
          hintStyle: TextStyle(color: hint.withOpacity(0.5), fontSize: 18),
          labelText: _isGrossToNet ? "Aylık Brüt Tutar" : "Aylık Net Tutar",
          labelStyle: TextStyle(color: hint),
          suffixText: "₺",
          border: InputBorder.none,
          icon: Icon(Icons.account_balance_wallet_rounded, color: primary),
        ),
      ),
    );
  }

  Widget _buildMonthlyInputs(Color bg, Color text, Color hint) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        childAspectRatio: 1.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hint.withOpacity(0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: TextField(
            controller: _monthlyControllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: text),
            decoration: InputDecoration(
              labelText: _service.months[index].substring(0, 3), 
              labelStyle: TextStyle(fontSize: 12, color: hint),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(bool isDark, Color accent) {
    double totalNet = _results.fold(0, (sum, item) => sum + item.netEleGecen); // Düzeltildi
    double avgNet = totalNet / 12;
    return Row(children: [
      Expanded(child: _summaryBox("Ortalama Net", avgNet, isDark ? Colors.orange.shade200 : Colors.orange.shade800, isDark ? Colors.orange.shade900.withOpacity(0.2) : Colors.orange.shade50)),
      const SizedBox(width: 12),
      Expanded(child: _summaryBox("Yıllık Toplam", totalNet, accent, accent.withOpacity(0.1))),
    ]);
  }
  
  Widget _summaryBox(String title, double value, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text("₺${NumberFormat("#,##0", "tr_TR").format(value)}", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    );
  }

  Widget _buildResultsList(Color textSec, Color cardColor, Color bg, Color textMain) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _results.length,
      itemBuilder: (context, index) => _buildMonthCard(_results[index], cardColor, bg, textSec, textMain),
    );
  }

  Widget _buildMonthCard(SalaryResult r, Color cardColor, Color bg, Color textSec, Color textMain) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetailSheet(r, cardColor, bg, textMain, textSec),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(children: [
            Container(width: 48, height: 48, alignment: Alignment.center, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)), child: Text(r.month.substring(0, 3).toUpperCase(), style: TextStyle(color: textSec, fontWeight: FontWeight.w800, fontSize: 13))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Ele Geçen", style: TextStyle(color: textSec, fontSize: 11, fontWeight: FontWeight.w600)), const SizedBox(height: 2), Text("₺${NumberFormat("#,##0.00", "tr_TR").format(r.netEleGecen)}", style: TextStyle(color: textMain, fontWeight: FontWeight.w800, fontSize: 17))])), // Düzeltildi
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(_isGrossToNet ? "Brüt Tutar" : "Brüt", style: TextStyle(color: textSec, fontSize: 11)), const SizedBox(height: 2), Text("₺${NumberFormat("#,##0", "tr_TR").format(r.brut)}", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 14))]),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
          ]),
        ),
      ),
    );
  }

  void _showDetailSheet(SalaryResult r, Color cardColor, Color bg, Color textMain, Color textSec) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(color: cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Row(children: [Text("${r.month} Detayları", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textMain)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)), child: Text("Brüt: ${NumberFormat("#,##0.00", "tr_TR").format(r.brut)}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textSec)))]),
          const SizedBox(height: 30),
          _detailRow("SGK İşçi Payı (%14)", r.sgkIsci, isNegative: true, textMain: textMain, textSec: textSec),
          _detailRow("İşsizlik Payı (%1)", r.issizlikIsci, isNegative: true, textMain: textMain, textSec: textSec),
          _detailRow("Damga Vergisi", r.damgaVergisi, isNegative: true, textMain: textMain, textSec: textSec),
          const Divider(height: 30),
          _detailRow("Gelir Vergisi", r.gelirVergisi, subText: "İstisna öncesi", textMain: textMain, textSec: textSec),
          _detailRow("GV İstisnası", r.gvIstisnaTutari, color: const Color(0xFF10B981), prefix: "+", textMain: textMain, textSec: textSec), // Düzeltildi
          const Divider(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("NET ELE GEÇEN", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF10B981))), Text("₺${NumberFormat("#,##0.00", "tr_TR").format(r.netEleGecen)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textMain))]), // Düzeltildi
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, double value, {bool isNegative = false, bool isBold = false, double fontSize = 14, Color? color, String? subText, String prefix = "", required Color textMain, required Color textSec}) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: textMain)), if (subText != null) Text(subText, style: TextStyle(fontSize: 11, color: textSec))]), Text("${isNegative ? '-' : prefix}${NumberFormat("#,##0.00", "tr_TR").format(value)} ₺", style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: color ?? (isNegative ? Colors.redAccent : textMain)))]));
  }

  Widget _buildSaveButton(Color primary, Color accent) {
    return SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _saveToDb, icon: const Icon(Icons.save_alt_rounded, color: Colors.white), label: const Text("KAYDET", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 4, shadowColor: primary.withOpacity(0.4))));
  }
  
  Widget _buildEmptyState(Color textSec) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const SizedBox(height: 60), Icon(Icons.calculate_outlined, size: 80, color: Colors.grey.shade300), const SizedBox(height: 16), Text("Hesaplamak için maaş giriniz", style: TextStyle(color: textSec, fontWeight: FontWeight.w600))]));
  }
}

// ==============================================================================
// 4. ANİMASYON WIDGETLARI
// ==============================================================================

class CountingText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const CountingText({
    super.key,
    required this.value,
    this.style,
    this.prefix = "",
    this.suffix = "",
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(seconds: 2), 
      curve: Curves.easeOutExpo, 
      builder: (context, val, child) {
        final fmt = NumberFormat("#,##0.00", "tr_TR").format(val);
        return Text(
          "$prefix$fmt$suffix",
          style: style,
        );
      },
    );
  }
}

class _SlideInItem extends StatefulWidget {
  final Widget child;
  final int delay;

  const _SlideInItem({required this.child, required this.delay});

  @override
  State<_SlideInItem> createState() => _SlideInItemState();
}

class _SlideInItemState extends State<_SlideInItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _offsetAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _offsetAnim,
        child: widget.child,
      ),
    );
  }
}
