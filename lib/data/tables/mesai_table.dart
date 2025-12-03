import 'package:drift/drift.dart';

class MesaiTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get tarih => dateTime()();
  RealColumn get saat => real()();
  RealColumn get ucret => real()();
  
  // 🔥 EKSİK OLAN SÜTUNLAR EKLENDİ:
  RealColumn get carpan => real().withDefault(const Constant(1.5))(); // Mesai çarpanı
  TextColumn get aciklama => text().nullable()(); // Açıklama/Not
}