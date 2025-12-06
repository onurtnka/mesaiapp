import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

import '../../core/app_database.dart';
import 'add_mesai_screen.dart';

class AllMesaiScreen extends StatefulWidget {
  const AllMesaiScreen({super.key});

  @override
  State<AllMesaiScreen> createState() => _AllMesaiScreenState();
}

class _AllMesaiScreenState extends State<AllMesaiScreen> {
  late AppDatabase db;
  late Stream<List<MesaiTableData>> _mesaiStream;
  
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);
    
    db = context.read<AppDatabase>();
    
    _mesaiStream = (db.select(db.mesaiTable)
          ..orderBy([(t) => drift.OrderingTerm(expression: t.tarih, mode: drift.OrderingMode.desc)]))
        .watch();
  }

  Map<String, List<MesaiTableData>> _groupData(List<MesaiTableData> list) {
    final Map<String, List<MesaiTableData>> grouped = {};
    for (var item in list) {
      final key = DateFormat("MMMM yyyy", "tr_TR").format(item.tarih);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Future<void> _confirmDelete(MesaiTableData item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Silinsin mi?"),
        content: const Text("Bu mesai kaydını kalıcı olarak silmek istiyor musunuz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("İptal", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Sil", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirm == true) {
      await db.delete(db.mesaiTable).delete(item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kayıt silindi"), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colBg = isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
    final colText = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: colBg,
      appBar: AppBar(
        title: Text("Kayıtlar", style: TextStyle(color: colText, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colText),
        centerTitle: true,
      ),
      body: StreamBuilder<List<MesaiTableData>>(
        stream: _mesaiStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final allList = snapshot.data!;
          
          if (allList.isEmpty) {
            return _buildEmptyState();
          }

          final groupedData = _groupData(allList);
          final allMonths = groupedData.keys.toList();

          Map<String, List<MesaiTableData>> displayData = {};
          if (_selectedFilter != null && groupedData.containsKey(_selectedFilter)) {
            displayData[_selectedFilter!] = groupedData[_selectedFilter!]!;
          } else {
            displayData = groupedData;
          }

          return Column(
            children: [
              _buildFilterBar(allMonths, isDark),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: displayData.keys.length,
                  itemBuilder: (context, index) {
                    final monthKey = displayData.keys.elementAt(index);
                    final items = displayData[monthKey]!;
                    
                    // 🔥 HESAPLAMA: O ayın toplam tutarı
                    final monthTotal = items.fold<double>(0, (sum, item) => sum + item.ucret);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AY BAŞLIĞI + TOPLAM TUTAR
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                monthKey.toUpperCase(),
                                style: TextStyle(
                                  color: isDark ? Colors.blue.shade200 : Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              // 🔥 TOPLAM GÖSTERGESİ
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Toplam: ₺${monthTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        ...items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDismissibleItem(item, isDark),
                        )),
                        
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(List<String> months, bool isDark) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _filterChip("Tümü", _selectedFilter == null, () => setState(() => _selectedFilter = null), isDark),
          
          ...months.map((m) => _filterChip(
            m, 
            _selectedFilter == m, 
            () => setState(() => _selectedFilter = m), 
            isDark
          )),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap, bool isDark) {
    final activeColor = const Color(0xFF3B82F6);
    final inactiveBg = isDark ? Colors.white10 : Colors.white;
    final inactiveBorder = isDark ? Colors.white24 : Colors.grey.shade300;
    final inactiveText = isDark ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : inactiveBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? activeColor : inactiveBorder),
          boxShadow: isSelected ? [BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : inactiveText,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.fileX, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text("Henüz kayıt bulunmuyor", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildDismissibleItem(MesaiTableData item, bool isDark) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _confirmDelete(item);
        return false; 
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(LucideIcons.trash2, color: Colors.white),
      ),
      child: _buildTransactionTile(item, isDark),
    );
  }

  Widget _buildTransactionTile(MesaiTableData item, bool isDark) {
    final colCard = isDark ? const Color(0xFF1F2937) : Colors.white;
    final colTextMain = isDark ? Colors.white : const Color(0xFF1E293B);
    final colTextSec = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final colPrimary = const Color(0xFF3B82F6);

    String dateStr = "";
    try {
      dateStr = DateFormat("d MMMM, EEEE", "tr_TR").format(item.tarih);
    } catch (_) {
      dateStr = "${item.tarih.day}/${item.tarih.month}";
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMesaiScreen(editItem: item),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(LucideIcons.pencil, color: colPrimary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item.aciklama == null || item.aciklama!.isEmpty) ? "Mesai Kaydı" : item.aciklama!,
                    style: TextStyle(color: colTextMain, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(dateStr, style: TextStyle(color: colTextSec, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("+₺${item.ucret.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w900, fontSize: 16)),
                Text("${item.saat} saat", style: TextStyle(color: colTextSec, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}