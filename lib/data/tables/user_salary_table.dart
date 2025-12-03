import 'package:drift/drift.dart';

class UserSalaryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get monthlyBrut => real()();
  RealColumn get monthlyNet => real()();

  RealColumn get sgkIsci => real()();
  RealColumn get issizlikIsci => real()();
  RealColumn get sgkIsveren => real()();
  RealColumn get issizlikIsveren => real()();
  RealColumn get damga => real()();
  RealColumn get gvDilimi => real()();
  RealColumn get kumulatifMatrah => real()();

  RealColumn get hourlyRateNet => real().withDefault(const Constant(0))();
  RealColumn get hourlyRateBrut => real().withDefault(const Constant(0))();
}
