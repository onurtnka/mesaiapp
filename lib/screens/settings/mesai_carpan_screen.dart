import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:drift/drift.dart' show Value;
import 'package:provider/provider.dart';

import '../../core/app_database.dart';

class MesaiCarpanScreen extends StatefulWidget {
  const MesaiCarpanScreen({super.key});

  @override
  State<MesaiCarpanScreen> createState() => _MesaiCarpanScreenState();
}

class _MesaiCarpanScreenState extends State<MesaiCarpanScreen> {
  final TextEditingController weekdayCtrl = TextEditingController();
  final TextEditingController weekendCtrl = TextEditingController();
  final TextEditingController nightCtrl = TextEditingController();
late AppDatabase db;
  @override
  void initState() {
    super.initState();
    db = context.read<AppDatabase>();
    loadData();
  }

  Future<void> loadData() async {
    final settings = await db.select(db.userSettingsTable).get();
    if (settings.isNotEmpty) {
      final s = settings.first;

      weekdayCtrl.text = s.overtimeWeekday;
      weekendCtrl.text = s.overtimeWeekend;
      nightCtrl.text = s.overtimeNight;
    }
    setState(() {});
  }

  Future<void> saveData() async {
    final settings = await db.select(db.userSettingsTable).get();
    if (settings.isEmpty) return;

    final s = settings.first;

    await db.update(db.userSettingsTable).write(
      UserSettingsTableCompanion(
        id: Value(s.id),
        overtimeWeekday: Value(weekdayCtrl.text),
        overtimeWeekend: Value(weekendCtrl.text),
        overtimeNight: Value(nightCtrl.text),
      ),
    );

    Navigator.pop(context);
  }

  Widget _field(String label, TextEditingController c, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFE2E8F0)),
            color: Colors.white,
          ),
          child: TextField(
            controller: c,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: Icon(icon),
              border: InputBorder.none,
              hintText: "Örn: 1.5",
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesai Çarpanları"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field("Hafta içi mesai çarpanı", weekdayCtrl, LucideIcons.badgePercent),
            _field("Hafta sonu mesai çarpanı", weekendCtrl, LucideIcons.badgePercent),
            _field("Gece mesai çarpanı", nightCtrl, LucideIcons.moon),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: saveData,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Kaydet",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
