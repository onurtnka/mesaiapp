import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Bu satır gerekli
import '../../core/app_database.dart';

class AddMesaiScreen extends StatefulWidget {
  const AddMesaiScreen({super.key});

  @override
  State<AddMesaiScreen> createState() => _AddMesaiScreenState();
}

class _AddMesaiScreenState extends State<AddMesaiScreen> {
  // Form Değerleri
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  // Mesai Türü (Varsayılan değerler)
  double _multiplier = 1.5; // 1.5 = %50 Zamlı
  String _selectedType = "Hafta İçi";

  // DB'den gelecek veriler
  double _hourlyRate = 0;
  bool _isLoading = true;

  @override
void initState() {
  super.initState();
  initializeDateFormatting('tr_TR', null); // Bu satır hatayı çözer
  _loadHourlyRate();
}

  // Maaş tablosundan son kaydedilen saatlik net ücreti çek
  Future<void> _loadHourlyRate() async {
    final db = context.read<AppDatabase>();
    final salaries = await db.select(db.userSalaryTable).get();
    
    if (salaries.isNotEmpty && mounted) {
      setState(() {
        _hourlyRate = salaries.last.hourlyRateNet ?? 0;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // Tahmini kazanç hesabı
  double get _estimatedEarnings {
    final hours = double.tryParse(_hoursController.text.replaceAll(',', '.')) ?? 0;
    return hours * _hourlyRate * _multiplier;
  }

  Future<void> _save() async {
    if (_hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen saat giriniz")));
      return;
    }

    final db = context.read<AppDatabase>();
    final hours = double.parse(_hoursController.text.replaceAll(',', '.'));
    final amount = hours * _hourlyRate * _multiplier;

    // Veritabanına Ekle
    await db.into(db.mesaiTable).insert(MesaiTableCompanion(
      tarih: drift.Value(_selectedDate),
      saat: drift.Value(hours),
      ucret: drift.Value(amount),
      aciklama: drift.Value(_descController.text),
      carpan: drift.Value(_multiplier), // Eğer tablonuzda carpan kolonu varsa
    ));

    if (mounted) {
      Navigator.pop(context, true); // true = Veri eklendi, sayfayı yenile
    }
  }

  // --- UI RENKLERİ ---
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _colBg => _isDark ? const Color(0xFF111827) : const Color(0xFFF4F6F9);
  Color get _colCard => _isDark ? const Color(0xFF1F2937) : Colors.white;
  Color get _colText => _isDark ? Colors.white : const Color(0xFF1F2937);
  Color get _colPrimary => const Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBg,
      appBar: AppBar(
        title: Text("Mesai Ekle", style: TextStyle(color: _colText, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _colText),
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: _colPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEarningsCard(),
                  const SizedBox(height: 24),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  _buildTypeSelector(),
                  const SizedBox(height: 16),
                  _buildHourInput(),
                  const SizedBox(height: 16),
                  _buildDescInput(),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  // 1. TAHMİNİ KAZANÇ KARTI (HEADER)
  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_colPrimary, const Color(0xFF2563EB)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: _colPrimary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          const Text("Tahmini Kazanç", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            "₺${_estimatedEarnings.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
            child: Text("Saatlik: ₺${_hourlyRate.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  // 2. TARİH SEÇİCİ
  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context, 
          initialDate: _selectedDate, 
          firstDate: DateTime(2020), 
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(data: _isDark ? ThemeData.dark() : ThemeData.light(), child: child!);
          }
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _colCard, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(LucideIcons.calendar, color: _colPrimary),
            const SizedBox(width: 12),
            Text(DateFormat("d MMMM yyyy", "tr_TR").format(_selectedDate), style: TextStyle(color: _colText, fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(LucideIcons.chevronDown, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  // 3. MESAİ TÜRÜ SEÇİMİ (CHIPS)
  Widget _buildTypeSelector() {
    final types = [
      {"label": "Hafta İçi", "val": 1.5},
      {"label": "Hafta Sonu", "val": 1.5}, // Bazı yerlerde 2.0 olabilir
      {"label": "Resmî Tatil", "val": 2.0},
    ];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = types[index];
          final isSelected = _selectedType == item['label'];
          return ChoiceChip(
            label: Text(item['label'] as String),
            selected: isSelected,
            selectedColor: _colPrimary,
            labelStyle: TextStyle(color: isSelected ? Colors.white : _colText),
            backgroundColor: _colCard,
            onSelected: (val) {
              if (val) {
                setState(() {
                  _selectedType = item['label'] as String;
                  _multiplier = item['val'] as double;
                });
              }
            },
          );
        },
      ),
    );
  }

  // 4. SAAT GİRİŞİ
  Widget _buildHourInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: _colCard, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: _hoursController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: _colText, fontSize: 18, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Çalışma Süresi (Saat)",
          suffixText: "Saat",
        ),
        onChanged: (_) => setState(() {}), // UI güncelle (Kazanç için)
      ),
    );
  }

  // 5. AÇIKLAMA GİRİŞİ
  Widget _buildDescInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: _colCard, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: _descController,
        style: TextStyle(color: _colText),
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Not (Opsiyonel)",
          prefixIcon: Icon(LucideIcons.stickyNote, size: 20),
        ),
      ),
    );
  }

  // 6. KAYDET BUTONU
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981), // Yeşil
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: const Text("MESAİYİ KAYDET", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}