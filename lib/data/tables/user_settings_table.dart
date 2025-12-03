import 'package:drift/drift.dart';

class UserSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get workType =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('monthly'))();

  TextColumn get weeklyHours =>
      text().withLength(min: 1, max: 8).withDefault(const Constant('45'))();

  TextColumn get salaryType =>
      text().withLength(min: 1, max: 16).withDefault(const Constant('gross'))();

  TextColumn get salaryAmount =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('0'))();

  BoolColumn get hasPrivatePension =>
      boolean().withDefault(const Constant(false))();

  TextColumn get pensionAmount =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('0'))();

  BoolColumn get hasMealAllowance =>
      boolean().withDefault(const Constant(false))();

  TextColumn get mealAmount =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('0'))();

  BoolColumn get hasTransportAllowance =>
      boolean().withDefault(const Constant(false))();

  TextColumn get transportAmount =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('0'))();

  BoolColumn get hasBonus =>
      boolean().withDefault(const Constant(false))();

  TextColumn get bonusAmount =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('0'))();

  BoolColumn get hasShiftDiff =>
      boolean().withDefault(const Constant(false))();

  TextColumn get shiftDiffAmount =>
      text().withLength(min: 1, max: 32).withDefault(const Constant('0'))();

  TextColumn get overtimeWeekday =>
      text().withLength(min: 1, max: 16).withDefault(const Constant('1.5'))();

  TextColumn get overtimeWeekend =>
      text().withLength(min: 1, max: 16).withDefault(const Constant('2.0'))();

  TextColumn get overtimeNight =>
      text().withLength(min: 1, max: 16).withDefault(const Constant('1.25'))();

  TextColumn get currency =>
      text().withLength(min: 1, max: 12).withDefault(const Constant('TL'))();

  TextColumn get theme =>
      text().withLength(min: 1, max: 12).withDefault(const Constant('system'))();

  /// ⭐ YENİ EKLENDİ — Aylık çalışma saati (Varsayılan 225)
  IntColumn get monthlyWorkHours =>
      integer().withDefault(const Constant(225))();
}
