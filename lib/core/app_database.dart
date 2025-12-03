import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';

import '../data/tables/mesai_table.dart';
import '../data/tables/user_settings_table.dart';
import '../data/tables/user_salary_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MesaiTable,
    UserSettingsTable,
    UserSalaryTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // 🎯 Yeni schema

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await m.addColumn(userSalaryTable, userSalaryTable.hourlyRateNet);
            await m.addColumn(userSalaryTable, userSalaryTable.hourlyRateBrut);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final executor = await SqfliteQueryExecutor.inDatabaseFolder(
      path: 'mesai.sqlite',
      logStatements: true,
    );
    return executor;
  });
}
