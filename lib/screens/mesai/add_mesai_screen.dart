import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tarih formatı için

import '../../core/app_database.dart';

class AddMesaiScreen extends StatefulWidget {
  // Düzenleme için opsiyonel parametre
  final MesaiTableData? editItem;

  const AddMesaiScreen({super.key, this.editItem});

  @override
  State<AddMesaiScreen> createState() => _AddMesaiScreenState();
}

class _AddMesaiScreenState extends State<AddMesaiScreen> {
  // Form Değerleri
  late DateTime _selectedDate;
  late TextEditingController _hoursController;
  late TextEditingController _descController;
  
  double _multiplier = 1.5; 
  String _selectedType = "Hafta İçi";

  double _hourlyRate = 0;
  bool _isLoading = true;

  // Düzenleme modunda mıyız?
  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);

    // Eğer düzenleme modundaysak, verileri mevcut kayıttan doldur
    if (_isEditing) {
      final item = widget.editItem!;
      _selectedDate = item.tarih;
      _hoursController = TextEditingController(text: item.saat.toString());
      _descController = TextEditingController(text: item.aciklama ?? "");
      _multiplier = item.carpan;
      
      // Çarpana göre buton seçimini ayarla
      if (_multiplier == 1.5) _selectedType = "Hafta İçi"; // Varsayılan
      if (_multiplier == 2.0) _selectedType = "Resmî Tatil";
      
      // Düzenleme yaparken, o kaydın hesaplandığı saatlik ücreti korumaya çalışalım
      // Formül: Tutar = Saat * Oran * Çarpan  =>  Oran = Tutar / (Saat * Çarpan)
      if (item.saat > 0) {
        _hourlyRate = item.ucret / (item.saat * item.carpan);
      }
      _isLoading = false;
    } else {
      // Yeni kayıt modu
      _selectedDate = DateTime.now();
      _hoursController = TextEditingController();
      _descController = TextEditingController();
      
      // Saatlik ücreti çek
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHourlyRate();
      });
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadHourlyRate() async {
    final db = context.read<AppDatabase>();
    try {
      final salaries = await db.select(db.userSalaryTable).get();
      
      if (salaries.isNotEmpty && mounted) {
        setState(() {
          _hourlyRate = salaries.last.hourlyRateNet ?? 0;
          _isLoading = false;
        });
      } else {
        if (mounted) {
           setState(() => _isLoading = false);
           // Maaş yok uyarısı
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Önce Maaş Hesaplama ekranından maaşınızı kaydedin!")),
           );
        }
      }
    } catch (e) {
      debugPrint("Saatlik ücret yükleme hatası: $e");
      if(mounted) setState(() => _isLoading = false);
    }
  }

  double get _estimatedEarnings {
    final hours = double.tryParse(_hoursController.text.replaceAll(',', '.')) ?? 0;
    return hours * _hourlyRate * _multiplier;
  }

  Future<void> _save() async {
    if (_hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen saat giriniz")));
      return;
    }

    if (_hourlyRate == 0) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saatlik ücret bulunamadı. Lütfen önce maaş hesaplayıp kaydedin.")));
       return;
    }

    final db = context.read<AppDatabase>();
    final hours = double.parse(_hoursController.text.replaceAll(',', '.'));
    final amount = hours * _hourlyRate * _multiplier;

    if (_isEditing) {
      // GÜNCELLEME İŞLEMİ
      final updatedItem = widget.editItem!.copyWith(
        tarih: _selectedDate,
        saat: hours,
        ucret: amount,
        aciklama: drift.Value(_descController.text),
        carpan: _multiplier,
      );
      
      await db.update(db.mesaiTable).replace(updatedItem);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt güncellendi")));
        Navigator.pop(context, true);
      }
    } else {
      // YENİ KAYIT İŞLEMİ
      await db.into(db.mesaiTable).insert(MesaiTableCompanion(
        tarih: drift.Value(_selectedDate),
        saat: drift.Value(hours),
        ucret: drift.Value(amount),
        aciklama: drift.Value(_descController.text),
        carpan: drift.Value(_multiplier),
      ));
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

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
        title: Text(_isEditing ? "Mesai Düzenle" : "Mesai Ekle", style: TextStyle(color: _colText, fontWeight: FontWeight.bold)),
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

  // ... WIDGETLAR (Aynı kalacak, sadece içerik dinamikleşti) ...
  
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
          Text(_isEditing ? "Güncel Tutar" : "Tahmini Kazanç", style: const TextStyle(color: Colors.white70, fontSize: 14)),
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

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context, 
          initialDate: _selectedDate, 
          firstDate: DateTime(2020), 
          lastDate: DateTime(2030),
          builder: (context, child) => Theme(data: _isDark ? ThemeData.dark() : ThemeData.light(), child: child!)
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

  Widget _buildTypeSelector() {
    final types = [
      {"label": "Hafta İçi", "val": 1.5},
      {"label": "Hafta Sonu", "val": 1.5}, 
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
        onChanged: (_) => setState(() {}), 
      ),
    );
  }

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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981), 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: Text(_isEditing ? "KAYDI GÜNCELLE" : "MESAİYİ KAYDET", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}