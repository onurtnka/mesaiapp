// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MesaiTableTable extends MesaiTable
    with TableInfo<$MesaiTableTable, MesaiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MesaiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tarihMeta = const VerificationMeta('tarih');
  @override
  late final GeneratedColumn<DateTime> tarih = GeneratedColumn<DateTime>(
      'tarih', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _saatMeta = const VerificationMeta('saat');
  @override
  late final GeneratedColumn<double> saat = GeneratedColumn<double>(
      'saat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ucretMeta = const VerificationMeta('ucret');
  @override
  late final GeneratedColumn<double> ucret = GeneratedColumn<double>(
      'ucret', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _carpanMeta = const VerificationMeta('carpan');
  @override
  late final GeneratedColumn<double> carpan = GeneratedColumn<double>(
      'carpan', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.5));
  static const VerificationMeta _aciklamaMeta =
      const VerificationMeta('aciklama');
  @override
  late final GeneratedColumn<String> aciklama = GeneratedColumn<String>(
      'aciklama', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tarih, saat, ucret, carpan, aciklama];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesai_table';
  @override
  VerificationContext validateIntegrity(Insertable<MesaiTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tarih')) {
      context.handle(
          _tarihMeta, tarih.isAcceptableOrUnknown(data['tarih']!, _tarihMeta));
    } else if (isInserting) {
      context.missing(_tarihMeta);
    }
    if (data.containsKey('saat')) {
      context.handle(
          _saatMeta, saat.isAcceptableOrUnknown(data['saat']!, _saatMeta));
    } else if (isInserting) {
      context.missing(_saatMeta);
    }
    if (data.containsKey('ucret')) {
      context.handle(
          _ucretMeta, ucret.isAcceptableOrUnknown(data['ucret']!, _ucretMeta));
    } else if (isInserting) {
      context.missing(_ucretMeta);
    }
    if (data.containsKey('carpan')) {
      context.handle(_carpanMeta,
          carpan.isAcceptableOrUnknown(data['carpan']!, _carpanMeta));
    }
    if (data.containsKey('aciklama')) {
      context.handle(_aciklamaMeta,
          aciklama.isAcceptableOrUnknown(data['aciklama']!, _aciklamaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MesaiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MesaiTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tarih: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tarih'])!,
      saat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}saat'])!,
      ucret: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ucret'])!,
      carpan: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carpan'])!,
      aciklama: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aciklama']),
    );
  }

  @override
  $MesaiTableTable createAlias(String alias) {
    return $MesaiTableTable(attachedDatabase, alias);
  }
}

class MesaiTableData extends DataClass implements Insertable<MesaiTableData> {
  final int id;
  final DateTime tarih;
  final double saat;
  final double ucret;
  final double carpan;
  final String? aciklama;
  const MesaiTableData(
      {required this.id,
      required this.tarih,
      required this.saat,
      required this.ucret,
      required this.carpan,
      this.aciklama});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tarih'] = Variable<DateTime>(tarih);
    map['saat'] = Variable<double>(saat);
    map['ucret'] = Variable<double>(ucret);
    map['carpan'] = Variable<double>(carpan);
    if (!nullToAbsent || aciklama != null) {
      map['aciklama'] = Variable<String>(aciklama);
    }
    return map;
  }

  MesaiTableCompanion toCompanion(bool nullToAbsent) {
    return MesaiTableCompanion(
      id: Value(id),
      tarih: Value(tarih),
      saat: Value(saat),
      ucret: Value(ucret),
      carpan: Value(carpan),
      aciklama: aciklama == null && nullToAbsent
          ? const Value.absent()
          : Value(aciklama),
    );
  }

  factory MesaiTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MesaiTableData(
      id: serializer.fromJson<int>(json['id']),
      tarih: serializer.fromJson<DateTime>(json['tarih']),
      saat: serializer.fromJson<double>(json['saat']),
      ucret: serializer.fromJson<double>(json['ucret']),
      carpan: serializer.fromJson<double>(json['carpan']),
      aciklama: serializer.fromJson<String?>(json['aciklama']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tarih': serializer.toJson<DateTime>(tarih),
      'saat': serializer.toJson<double>(saat),
      'ucret': serializer.toJson<double>(ucret),
      'carpan': serializer.toJson<double>(carpan),
      'aciklama': serializer.toJson<String?>(aciklama),
    };
  }

  MesaiTableData copyWith(
          {int? id,
          DateTime? tarih,
          double? saat,
          double? ucret,
          double? carpan,
          Value<String?> aciklama = const Value.absent()}) =>
      MesaiTableData(
        id: id ?? this.id,
        tarih: tarih ?? this.tarih,
        saat: saat ?? this.saat,
        ucret: ucret ?? this.ucret,
        carpan: carpan ?? this.carpan,
        aciklama: aciklama.present ? aciklama.value : this.aciklama,
      );
  MesaiTableData copyWithCompanion(MesaiTableCompanion data) {
    return MesaiTableData(
      id: data.id.present ? data.id.value : this.id,
      tarih: data.tarih.present ? data.tarih.value : this.tarih,
      saat: data.saat.present ? data.saat.value : this.saat,
      ucret: data.ucret.present ? data.ucret.value : this.ucret,
      carpan: data.carpan.present ? data.carpan.value : this.carpan,
      aciklama: data.aciklama.present ? data.aciklama.value : this.aciklama,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MesaiTableData(')
          ..write('id: $id, ')
          ..write('tarih: $tarih, ')
          ..write('saat: $saat, ')
          ..write('ucret: $ucret, ')
          ..write('carpan: $carpan, ')
          ..write('aciklama: $aciklama')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tarih, saat, ucret, carpan, aciklama);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MesaiTableData &&
          other.id == this.id &&
          other.tarih == this.tarih &&
          other.saat == this.saat &&
          other.ucret == this.ucret &&
          other.carpan == this.carpan &&
          other.aciklama == this.aciklama);
}

class MesaiTableCompanion extends UpdateCompanion<MesaiTableData> {
  final Value<int> id;
  final Value<DateTime> tarih;
  final Value<double> saat;
  final Value<double> ucret;
  final Value<double> carpan;
  final Value<String?> aciklama;
  const MesaiTableCompanion({
    this.id = const Value.absent(),
    this.tarih = const Value.absent(),
    this.saat = const Value.absent(),
    this.ucret = const Value.absent(),
    this.carpan = const Value.absent(),
    this.aciklama = const Value.absent(),
  });
  MesaiTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime tarih,
    required double saat,
    required double ucret,
    this.carpan = const Value.absent(),
    this.aciklama = const Value.absent(),
  })  : tarih = Value(tarih),
        saat = Value(saat),
        ucret = Value(ucret);
  static Insertable<MesaiTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? tarih,
    Expression<double>? saat,
    Expression<double>? ucret,
    Expression<double>? carpan,
    Expression<String>? aciklama,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tarih != null) 'tarih': tarih,
      if (saat != null) 'saat': saat,
      if (ucret != null) 'ucret': ucret,
      if (carpan != null) 'carpan': carpan,
      if (aciklama != null) 'aciklama': aciklama,
    });
  }

  MesaiTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? tarih,
      Value<double>? saat,
      Value<double>? ucret,
      Value<double>? carpan,
      Value<String?>? aciklama}) {
    return MesaiTableCompanion(
      id: id ?? this.id,
      tarih: tarih ?? this.tarih,
      saat: saat ?? this.saat,
      ucret: ucret ?? this.ucret,
      carpan: carpan ?? this.carpan,
      aciklama: aciklama ?? this.aciklama,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tarih.present) {
      map['tarih'] = Variable<DateTime>(tarih.value);
    }
    if (saat.present) {
      map['saat'] = Variable<double>(saat.value);
    }
    if (ucret.present) {
      map['ucret'] = Variable<double>(ucret.value);
    }
    if (carpan.present) {
      map['carpan'] = Variable<double>(carpan.value);
    }
    if (aciklama.present) {
      map['aciklama'] = Variable<String>(aciklama.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MesaiTableCompanion(')
          ..write('id: $id, ')
          ..write('tarih: $tarih, ')
          ..write('saat: $saat, ')
          ..write('ucret: $ucret, ')
          ..write('carpan: $carpan, ')
          ..write('aciklama: $aciklama')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workTypeMeta =
      const VerificationMeta('workType');
  @override
  late final GeneratedColumn<String> workType = GeneratedColumn<String>(
      'work_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _weeklyHoursMeta =
      const VerificationMeta('weeklyHours');
  @override
  late final GeneratedColumn<String> weeklyHours = GeneratedColumn<String>(
      'weekly_hours', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('45'));
  static const VerificationMeta _salaryTypeMeta =
      const VerificationMeta('salaryType');
  @override
  late final GeneratedColumn<String> salaryType = GeneratedColumn<String>(
      'salary_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('gross'));
  static const VerificationMeta _salaryAmountMeta =
      const VerificationMeta('salaryAmount');
  @override
  late final GeneratedColumn<String> salaryAmount = GeneratedColumn<String>(
      'salary_amount', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _hasPrivatePensionMeta =
      const VerificationMeta('hasPrivatePension');
  @override
  late final GeneratedColumn<bool> hasPrivatePension = GeneratedColumn<bool>(
      'has_private_pension', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_private_pension" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pensionAmountMeta =
      const VerificationMeta('pensionAmount');
  @override
  late final GeneratedColumn<String> pensionAmount = GeneratedColumn<String>(
      'pension_amount', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _hasMealAllowanceMeta =
      const VerificationMeta('hasMealAllowance');
  @override
  late final GeneratedColumn<bool> hasMealAllowance = GeneratedColumn<bool>(
      'has_meal_allowance', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_meal_allowance" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _mealAmountMeta =
      const VerificationMeta('mealAmount');
  @override
  late final GeneratedColumn<String> mealAmount = GeneratedColumn<String>(
      'meal_amount', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _hasTransportAllowanceMeta =
      const VerificationMeta('hasTransportAllowance');
  @override
  late final GeneratedColumn<bool> hasTransportAllowance =
      GeneratedColumn<bool>('has_transport_allowance', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("has_transport_allowance" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _transportAmountMeta =
      const VerificationMeta('transportAmount');
  @override
  late final GeneratedColumn<String> transportAmount = GeneratedColumn<String>(
      'transport_amount', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _hasBonusMeta =
      const VerificationMeta('hasBonus');
  @override
  late final GeneratedColumn<bool> hasBonus = GeneratedColumn<bool>(
      'has_bonus', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("has_bonus" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bonusAmountMeta =
      const VerificationMeta('bonusAmount');
  @override
  late final GeneratedColumn<String> bonusAmount = GeneratedColumn<String>(
      'bonus_amount', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _hasShiftDiffMeta =
      const VerificationMeta('hasShiftDiff');
  @override
  late final GeneratedColumn<bool> hasShiftDiff = GeneratedColumn<bool>(
      'has_shift_diff', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_shift_diff" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _shiftDiffAmountMeta =
      const VerificationMeta('shiftDiffAmount');
  @override
  late final GeneratedColumn<String> shiftDiffAmount = GeneratedColumn<String>(
      'shift_diff_amount', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _overtimeWeekdayMeta =
      const VerificationMeta('overtimeWeekday');
  @override
  late final GeneratedColumn<String> overtimeWeekday = GeneratedColumn<String>(
      'overtime_weekday', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1.5'));
  static const VerificationMeta _overtimeWeekendMeta =
      const VerificationMeta('overtimeWeekend');
  @override
  late final GeneratedColumn<String> overtimeWeekend = GeneratedColumn<String>(
      'overtime_weekend', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('2.0'));
  static const VerificationMeta _overtimeNightMeta =
      const VerificationMeta('overtimeNight');
  @override
  late final GeneratedColumn<String> overtimeNight = GeneratedColumn<String>(
      'overtime_night', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1.25'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 12),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('TL'));
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 12),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _monthlyWorkHoursMeta =
      const VerificationMeta('monthlyWorkHours');
  @override
  late final GeneratedColumn<int> monthlyWorkHours = GeneratedColumn<int>(
      'monthly_work_hours', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(225));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workType,
        weeklyHours,
        salaryType,
        salaryAmount,
        hasPrivatePension,
        pensionAmount,
        hasMealAllowance,
        mealAmount,
        hasTransportAllowance,
        transportAmount,
        hasBonus,
        bonusAmount,
        hasShiftDiff,
        shiftDiffAmount,
        overtimeWeekday,
        overtimeWeekend,
        overtimeNight,
        currency,
        theme,
        monthlyWorkHours
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_type')) {
      context.handle(_workTypeMeta,
          workType.isAcceptableOrUnknown(data['work_type']!, _workTypeMeta));
    }
    if (data.containsKey('weekly_hours')) {
      context.handle(
          _weeklyHoursMeta,
          weeklyHours.isAcceptableOrUnknown(
              data['weekly_hours']!, _weeklyHoursMeta));
    }
    if (data.containsKey('salary_type')) {
      context.handle(
          _salaryTypeMeta,
          salaryType.isAcceptableOrUnknown(
              data['salary_type']!, _salaryTypeMeta));
    }
    if (data.containsKey('salary_amount')) {
      context.handle(
          _salaryAmountMeta,
          salaryAmount.isAcceptableOrUnknown(
              data['salary_amount']!, _salaryAmountMeta));
    }
    if (data.containsKey('has_private_pension')) {
      context.handle(
          _hasPrivatePensionMeta,
          hasPrivatePension.isAcceptableOrUnknown(
              data['has_private_pension']!, _hasPrivatePensionMeta));
    }
    if (data.containsKey('pension_amount')) {
      context.handle(
          _pensionAmountMeta,
          pensionAmount.isAcceptableOrUnknown(
              data['pension_amount']!, _pensionAmountMeta));
    }
    if (data.containsKey('has_meal_allowance')) {
      context.handle(
          _hasMealAllowanceMeta,
          hasMealAllowance.isAcceptableOrUnknown(
              data['has_meal_allowance']!, _hasMealAllowanceMeta));
    }
    if (data.containsKey('meal_amount')) {
      context.handle(
          _mealAmountMeta,
          mealAmount.isAcceptableOrUnknown(
              data['meal_amount']!, _mealAmountMeta));
    }
    if (data.containsKey('has_transport_allowance')) {
      context.handle(
          _hasTransportAllowanceMeta,
          hasTransportAllowance.isAcceptableOrUnknown(
              data['has_transport_allowance']!, _hasTransportAllowanceMeta));
    }
    if (data.containsKey('transport_amount')) {
      context.handle(
          _transportAmountMeta,
          transportAmount.isAcceptableOrUnknown(
              data['transport_amount']!, _transportAmountMeta));
    }
    if (data.containsKey('has_bonus')) {
      context.handle(_hasBonusMeta,
          hasBonus.isAcceptableOrUnknown(data['has_bonus']!, _hasBonusMeta));
    }
    if (data.containsKey('bonus_amount')) {
      context.handle(
          _bonusAmountMeta,
          bonusAmount.isAcceptableOrUnknown(
              data['bonus_amount']!, _bonusAmountMeta));
    }
    if (data.containsKey('has_shift_diff')) {
      context.handle(
          _hasShiftDiffMeta,
          hasShiftDiff.isAcceptableOrUnknown(
              data['has_shift_diff']!, _hasShiftDiffMeta));
    }
    if (data.containsKey('shift_diff_amount')) {
      context.handle(
          _shiftDiffAmountMeta,
          shiftDiffAmount.isAcceptableOrUnknown(
              data['shift_diff_amount']!, _shiftDiffAmountMeta));
    }
    if (data.containsKey('overtime_weekday')) {
      context.handle(
          _overtimeWeekdayMeta,
          overtimeWeekday.isAcceptableOrUnknown(
              data['overtime_weekday']!, _overtimeWeekdayMeta));
    }
    if (data.containsKey('overtime_weekend')) {
      context.handle(
          _overtimeWeekendMeta,
          overtimeWeekend.isAcceptableOrUnknown(
              data['overtime_weekend']!, _overtimeWeekendMeta));
    }
    if (data.containsKey('overtime_night')) {
      context.handle(
          _overtimeNightMeta,
          overtimeNight.isAcceptableOrUnknown(
              data['overtime_night']!, _overtimeNightMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('monthly_work_hours')) {
      context.handle(
          _monthlyWorkHoursMeta,
          monthlyWorkHours.isAcceptableOrUnknown(
              data['monthly_work_hours']!, _monthlyWorkHoursMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_type'])!,
      weeklyHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekly_hours'])!,
      salaryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salary_type'])!,
      salaryAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salary_amount'])!,
      hasPrivatePension: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_private_pension'])!,
      pensionAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pension_amount'])!,
      hasMealAllowance: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_meal_allowance'])!,
      mealAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_amount'])!,
      hasTransportAllowance: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}has_transport_allowance'])!,
      transportAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transport_amount'])!,
      hasBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_bonus'])!,
      bonusAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bonus_amount'])!,
      hasShiftDiff: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_shift_diff'])!,
      shiftDiffAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shift_diff_amount'])!,
      overtimeWeekday: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}overtime_weekday'])!,
      overtimeWeekend: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}overtime_weekend'])!,
      overtimeNight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overtime_night'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      monthlyWorkHours: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}monthly_work_hours'])!,
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsTableData extends DataClass
    implements Insertable<UserSettingsTableData> {
  final int id;
  final String workType;
  final String weeklyHours;
  final String salaryType;
  final String salaryAmount;
  final bool hasPrivatePension;
  final String pensionAmount;
  final bool hasMealAllowance;
  final String mealAmount;
  final bool hasTransportAllowance;
  final String transportAmount;
  final bool hasBonus;
  final String bonusAmount;
  final bool hasShiftDiff;
  final String shiftDiffAmount;
  final String overtimeWeekday;
  final String overtimeWeekend;
  final String overtimeNight;
  final String currency;
  final String theme;

  /// ⭐ YENİ EKLENDİ — Aylık çalışma saati (Varsayılan 225)
  final int monthlyWorkHours;
  const UserSettingsTableData(
      {required this.id,
      required this.workType,
      required this.weeklyHours,
      required this.salaryType,
      required this.salaryAmount,
      required this.hasPrivatePension,
      required this.pensionAmount,
      required this.hasMealAllowance,
      required this.mealAmount,
      required this.hasTransportAllowance,
      required this.transportAmount,
      required this.hasBonus,
      required this.bonusAmount,
      required this.hasShiftDiff,
      required this.shiftDiffAmount,
      required this.overtimeWeekday,
      required this.overtimeWeekend,
      required this.overtimeNight,
      required this.currency,
      required this.theme,
      required this.monthlyWorkHours});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_type'] = Variable<String>(workType);
    map['weekly_hours'] = Variable<String>(weeklyHours);
    map['salary_type'] = Variable<String>(salaryType);
    map['salary_amount'] = Variable<String>(salaryAmount);
    map['has_private_pension'] = Variable<bool>(hasPrivatePension);
    map['pension_amount'] = Variable<String>(pensionAmount);
    map['has_meal_allowance'] = Variable<bool>(hasMealAllowance);
    map['meal_amount'] = Variable<String>(mealAmount);
    map['has_transport_allowance'] = Variable<bool>(hasTransportAllowance);
    map['transport_amount'] = Variable<String>(transportAmount);
    map['has_bonus'] = Variable<bool>(hasBonus);
    map['bonus_amount'] = Variable<String>(bonusAmount);
    map['has_shift_diff'] = Variable<bool>(hasShiftDiff);
    map['shift_diff_amount'] = Variable<String>(shiftDiffAmount);
    map['overtime_weekday'] = Variable<String>(overtimeWeekday);
    map['overtime_weekend'] = Variable<String>(overtimeWeekend);
    map['overtime_night'] = Variable<String>(overtimeNight);
    map['currency'] = Variable<String>(currency);
    map['theme'] = Variable<String>(theme);
    map['monthly_work_hours'] = Variable<int>(monthlyWorkHours);
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      workType: Value(workType),
      weeklyHours: Value(weeklyHours),
      salaryType: Value(salaryType),
      salaryAmount: Value(salaryAmount),
      hasPrivatePension: Value(hasPrivatePension),
      pensionAmount: Value(pensionAmount),
      hasMealAllowance: Value(hasMealAllowance),
      mealAmount: Value(mealAmount),
      hasTransportAllowance: Value(hasTransportAllowance),
      transportAmount: Value(transportAmount),
      hasBonus: Value(hasBonus),
      bonusAmount: Value(bonusAmount),
      hasShiftDiff: Value(hasShiftDiff),
      shiftDiffAmount: Value(shiftDiffAmount),
      overtimeWeekday: Value(overtimeWeekday),
      overtimeWeekend: Value(overtimeWeekend),
      overtimeNight: Value(overtimeNight),
      currency: Value(currency),
      theme: Value(theme),
      monthlyWorkHours: Value(monthlyWorkHours),
    );
  }

  factory UserSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      workType: serializer.fromJson<String>(json['workType']),
      weeklyHours: serializer.fromJson<String>(json['weeklyHours']),
      salaryType: serializer.fromJson<String>(json['salaryType']),
      salaryAmount: serializer.fromJson<String>(json['salaryAmount']),
      hasPrivatePension: serializer.fromJson<bool>(json['hasPrivatePension']),
      pensionAmount: serializer.fromJson<String>(json['pensionAmount']),
      hasMealAllowance: serializer.fromJson<bool>(json['hasMealAllowance']),
      mealAmount: serializer.fromJson<String>(json['mealAmount']),
      hasTransportAllowance:
          serializer.fromJson<bool>(json['hasTransportAllowance']),
      transportAmount: serializer.fromJson<String>(json['transportAmount']),
      hasBonus: serializer.fromJson<bool>(json['hasBonus']),
      bonusAmount: serializer.fromJson<String>(json['bonusAmount']),
      hasShiftDiff: serializer.fromJson<bool>(json['hasShiftDiff']),
      shiftDiffAmount: serializer.fromJson<String>(json['shiftDiffAmount']),
      overtimeWeekday: serializer.fromJson<String>(json['overtimeWeekday']),
      overtimeWeekend: serializer.fromJson<String>(json['overtimeWeekend']),
      overtimeNight: serializer.fromJson<String>(json['overtimeNight']),
      currency: serializer.fromJson<String>(json['currency']),
      theme: serializer.fromJson<String>(json['theme']),
      monthlyWorkHours: serializer.fromJson<int>(json['monthlyWorkHours']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workType': serializer.toJson<String>(workType),
      'weeklyHours': serializer.toJson<String>(weeklyHours),
      'salaryType': serializer.toJson<String>(salaryType),
      'salaryAmount': serializer.toJson<String>(salaryAmount),
      'hasPrivatePension': serializer.toJson<bool>(hasPrivatePension),
      'pensionAmount': serializer.toJson<String>(pensionAmount),
      'hasMealAllowance': serializer.toJson<bool>(hasMealAllowance),
      'mealAmount': serializer.toJson<String>(mealAmount),
      'hasTransportAllowance': serializer.toJson<bool>(hasTransportAllowance),
      'transportAmount': serializer.toJson<String>(transportAmount),
      'hasBonus': serializer.toJson<bool>(hasBonus),
      'bonusAmount': serializer.toJson<String>(bonusAmount),
      'hasShiftDiff': serializer.toJson<bool>(hasShiftDiff),
      'shiftDiffAmount': serializer.toJson<String>(shiftDiffAmount),
      'overtimeWeekday': serializer.toJson<String>(overtimeWeekday),
      'overtimeWeekend': serializer.toJson<String>(overtimeWeekend),
      'overtimeNight': serializer.toJson<String>(overtimeNight),
      'currency': serializer.toJson<String>(currency),
      'theme': serializer.toJson<String>(theme),
      'monthlyWorkHours': serializer.toJson<int>(monthlyWorkHours),
    };
  }

  UserSettingsTableData copyWith(
          {int? id,
          String? workType,
          String? weeklyHours,
          String? salaryType,
          String? salaryAmount,
          bool? hasPrivatePension,
          String? pensionAmount,
          bool? hasMealAllowance,
          String? mealAmount,
          bool? hasTransportAllowance,
          String? transportAmount,
          bool? hasBonus,
          String? bonusAmount,
          bool? hasShiftDiff,
          String? shiftDiffAmount,
          String? overtimeWeekday,
          String? overtimeWeekend,
          String? overtimeNight,
          String? currency,
          String? theme,
          int? monthlyWorkHours}) =>
      UserSettingsTableData(
        id: id ?? this.id,
        workType: workType ?? this.workType,
        weeklyHours: weeklyHours ?? this.weeklyHours,
        salaryType: salaryType ?? this.salaryType,
        salaryAmount: salaryAmount ?? this.salaryAmount,
        hasPrivatePension: hasPrivatePension ?? this.hasPrivatePension,
        pensionAmount: pensionAmount ?? this.pensionAmount,
        hasMealAllowance: hasMealAllowance ?? this.hasMealAllowance,
        mealAmount: mealAmount ?? this.mealAmount,
        hasTransportAllowance:
            hasTransportAllowance ?? this.hasTransportAllowance,
        transportAmount: transportAmount ?? this.transportAmount,
        hasBonus: hasBonus ?? this.hasBonus,
        bonusAmount: bonusAmount ?? this.bonusAmount,
        hasShiftDiff: hasShiftDiff ?? this.hasShiftDiff,
        shiftDiffAmount: shiftDiffAmount ?? this.shiftDiffAmount,
        overtimeWeekday: overtimeWeekday ?? this.overtimeWeekday,
        overtimeWeekend: overtimeWeekend ?? this.overtimeWeekend,
        overtimeNight: overtimeNight ?? this.overtimeNight,
        currency: currency ?? this.currency,
        theme: theme ?? this.theme,
        monthlyWorkHours: monthlyWorkHours ?? this.monthlyWorkHours,
      );
  UserSettingsTableData copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      workType: data.workType.present ? data.workType.value : this.workType,
      weeklyHours:
          data.weeklyHours.present ? data.weeklyHours.value : this.weeklyHours,
      salaryType:
          data.salaryType.present ? data.salaryType.value : this.salaryType,
      salaryAmount: data.salaryAmount.present
          ? data.salaryAmount.value
          : this.salaryAmount,
      hasPrivatePension: data.hasPrivatePension.present
          ? data.hasPrivatePension.value
          : this.hasPrivatePension,
      pensionAmount: data.pensionAmount.present
          ? data.pensionAmount.value
          : this.pensionAmount,
      hasMealAllowance: data.hasMealAllowance.present
          ? data.hasMealAllowance.value
          : this.hasMealAllowance,
      mealAmount:
          data.mealAmount.present ? data.mealAmount.value : this.mealAmount,
      hasTransportAllowance: data.hasTransportAllowance.present
          ? data.hasTransportAllowance.value
          : this.hasTransportAllowance,
      transportAmount: data.transportAmount.present
          ? data.transportAmount.value
          : this.transportAmount,
      hasBonus: data.hasBonus.present ? data.hasBonus.value : this.hasBonus,
      bonusAmount:
          data.bonusAmount.present ? data.bonusAmount.value : this.bonusAmount,
      hasShiftDiff: data.hasShiftDiff.present
          ? data.hasShiftDiff.value
          : this.hasShiftDiff,
      shiftDiffAmount: data.shiftDiffAmount.present
          ? data.shiftDiffAmount.value
          : this.shiftDiffAmount,
      overtimeWeekday: data.overtimeWeekday.present
          ? data.overtimeWeekday.value
          : this.overtimeWeekday,
      overtimeWeekend: data.overtimeWeekend.present
          ? data.overtimeWeekend.value
          : this.overtimeWeekend,
      overtimeNight: data.overtimeNight.present
          ? data.overtimeNight.value
          : this.overtimeNight,
      currency: data.currency.present ? data.currency.value : this.currency,
      theme: data.theme.present ? data.theme.value : this.theme,
      monthlyWorkHours: data.monthlyWorkHours.present
          ? data.monthlyWorkHours.value
          : this.monthlyWorkHours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableData(')
          ..write('id: $id, ')
          ..write('workType: $workType, ')
          ..write('weeklyHours: $weeklyHours, ')
          ..write('salaryType: $salaryType, ')
          ..write('salaryAmount: $salaryAmount, ')
          ..write('hasPrivatePension: $hasPrivatePension, ')
          ..write('pensionAmount: $pensionAmount, ')
          ..write('hasMealAllowance: $hasMealAllowance, ')
          ..write('mealAmount: $mealAmount, ')
          ..write('hasTransportAllowance: $hasTransportAllowance, ')
          ..write('transportAmount: $transportAmount, ')
          ..write('hasBonus: $hasBonus, ')
          ..write('bonusAmount: $bonusAmount, ')
          ..write('hasShiftDiff: $hasShiftDiff, ')
          ..write('shiftDiffAmount: $shiftDiffAmount, ')
          ..write('overtimeWeekday: $overtimeWeekday, ')
          ..write('overtimeWeekend: $overtimeWeekend, ')
          ..write('overtimeNight: $overtimeNight, ')
          ..write('currency: $currency, ')
          ..write('theme: $theme, ')
          ..write('monthlyWorkHours: $monthlyWorkHours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        workType,
        weeklyHours,
        salaryType,
        salaryAmount,
        hasPrivatePension,
        pensionAmount,
        hasMealAllowance,
        mealAmount,
        hasTransportAllowance,
        transportAmount,
        hasBonus,
        bonusAmount,
        hasShiftDiff,
        shiftDiffAmount,
        overtimeWeekday,
        overtimeWeekend,
        overtimeNight,
        currency,
        theme,
        monthlyWorkHours
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsTableData &&
          other.id == this.id &&
          other.workType == this.workType &&
          other.weeklyHours == this.weeklyHours &&
          other.salaryType == this.salaryType &&
          other.salaryAmount == this.salaryAmount &&
          other.hasPrivatePension == this.hasPrivatePension &&
          other.pensionAmount == this.pensionAmount &&
          other.hasMealAllowance == this.hasMealAllowance &&
          other.mealAmount == this.mealAmount &&
          other.hasTransportAllowance == this.hasTransportAllowance &&
          other.transportAmount == this.transportAmount &&
          other.hasBonus == this.hasBonus &&
          other.bonusAmount == this.bonusAmount &&
          other.hasShiftDiff == this.hasShiftDiff &&
          other.shiftDiffAmount == this.shiftDiffAmount &&
          other.overtimeWeekday == this.overtimeWeekday &&
          other.overtimeWeekend == this.overtimeWeekend &&
          other.overtimeNight == this.overtimeNight &&
          other.currency == this.currency &&
          other.theme == this.theme &&
          other.monthlyWorkHours == this.monthlyWorkHours);
}

class UserSettingsTableCompanion
    extends UpdateCompanion<UserSettingsTableData> {
  final Value<int> id;
  final Value<String> workType;
  final Value<String> weeklyHours;
  final Value<String> salaryType;
  final Value<String> salaryAmount;
  final Value<bool> hasPrivatePension;
  final Value<String> pensionAmount;
  final Value<bool> hasMealAllowance;
  final Value<String> mealAmount;
  final Value<bool> hasTransportAllowance;
  final Value<String> transportAmount;
  final Value<bool> hasBonus;
  final Value<String> bonusAmount;
  final Value<bool> hasShiftDiff;
  final Value<String> shiftDiffAmount;
  final Value<String> overtimeWeekday;
  final Value<String> overtimeWeekend;
  final Value<String> overtimeNight;
  final Value<String> currency;
  final Value<String> theme;
  final Value<int> monthlyWorkHours;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.workType = const Value.absent(),
    this.weeklyHours = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.salaryAmount = const Value.absent(),
    this.hasPrivatePension = const Value.absent(),
    this.pensionAmount = const Value.absent(),
    this.hasMealAllowance = const Value.absent(),
    this.mealAmount = const Value.absent(),
    this.hasTransportAllowance = const Value.absent(),
    this.transportAmount = const Value.absent(),
    this.hasBonus = const Value.absent(),
    this.bonusAmount = const Value.absent(),
    this.hasShiftDiff = const Value.absent(),
    this.shiftDiffAmount = const Value.absent(),
    this.overtimeWeekday = const Value.absent(),
    this.overtimeWeekend = const Value.absent(),
    this.overtimeNight = const Value.absent(),
    this.currency = const Value.absent(),
    this.theme = const Value.absent(),
    this.monthlyWorkHours = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.workType = const Value.absent(),
    this.weeklyHours = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.salaryAmount = const Value.absent(),
    this.hasPrivatePension = const Value.absent(),
    this.pensionAmount = const Value.absent(),
    this.hasMealAllowance = const Value.absent(),
    this.mealAmount = const Value.absent(),
    this.hasTransportAllowance = const Value.absent(),
    this.transportAmount = const Value.absent(),
    this.hasBonus = const Value.absent(),
    this.bonusAmount = const Value.absent(),
    this.hasShiftDiff = const Value.absent(),
    this.shiftDiffAmount = const Value.absent(),
    this.overtimeWeekday = const Value.absent(),
    this.overtimeWeekend = const Value.absent(),
    this.overtimeNight = const Value.absent(),
    this.currency = const Value.absent(),
    this.theme = const Value.absent(),
    this.monthlyWorkHours = const Value.absent(),
  });
  static Insertable<UserSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? workType,
    Expression<String>? weeklyHours,
    Expression<String>? salaryType,
    Expression<String>? salaryAmount,
    Expression<bool>? hasPrivatePension,
    Expression<String>? pensionAmount,
    Expression<bool>? hasMealAllowance,
    Expression<String>? mealAmount,
    Expression<bool>? hasTransportAllowance,
    Expression<String>? transportAmount,
    Expression<bool>? hasBonus,
    Expression<String>? bonusAmount,
    Expression<bool>? hasShiftDiff,
    Expression<String>? shiftDiffAmount,
    Expression<String>? overtimeWeekday,
    Expression<String>? overtimeWeekend,
    Expression<String>? overtimeNight,
    Expression<String>? currency,
    Expression<String>? theme,
    Expression<int>? monthlyWorkHours,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workType != null) 'work_type': workType,
      if (weeklyHours != null) 'weekly_hours': weeklyHours,
      if (salaryType != null) 'salary_type': salaryType,
      if (salaryAmount != null) 'salary_amount': salaryAmount,
      if (hasPrivatePension != null) 'has_private_pension': hasPrivatePension,
      if (pensionAmount != null) 'pension_amount': pensionAmount,
      if (hasMealAllowance != null) 'has_meal_allowance': hasMealAllowance,
      if (mealAmount != null) 'meal_amount': mealAmount,
      if (hasTransportAllowance != null)
        'has_transport_allowance': hasTransportAllowance,
      if (transportAmount != null) 'transport_amount': transportAmount,
      if (hasBonus != null) 'has_bonus': hasBonus,
      if (bonusAmount != null) 'bonus_amount': bonusAmount,
      if (hasShiftDiff != null) 'has_shift_diff': hasShiftDiff,
      if (shiftDiffAmount != null) 'shift_diff_amount': shiftDiffAmount,
      if (overtimeWeekday != null) 'overtime_weekday': overtimeWeekday,
      if (overtimeWeekend != null) 'overtime_weekend': overtimeWeekend,
      if (overtimeNight != null) 'overtime_night': overtimeNight,
      if (currency != null) 'currency': currency,
      if (theme != null) 'theme': theme,
      if (monthlyWorkHours != null) 'monthly_work_hours': monthlyWorkHours,
    });
  }

  UserSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? workType,
      Value<String>? weeklyHours,
      Value<String>? salaryType,
      Value<String>? salaryAmount,
      Value<bool>? hasPrivatePension,
      Value<String>? pensionAmount,
      Value<bool>? hasMealAllowance,
      Value<String>? mealAmount,
      Value<bool>? hasTransportAllowance,
      Value<String>? transportAmount,
      Value<bool>? hasBonus,
      Value<String>? bonusAmount,
      Value<bool>? hasShiftDiff,
      Value<String>? shiftDiffAmount,
      Value<String>? overtimeWeekday,
      Value<String>? overtimeWeekend,
      Value<String>? overtimeNight,
      Value<String>? currency,
      Value<String>? theme,
      Value<int>? monthlyWorkHours}) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      workType: workType ?? this.workType,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      salaryType: salaryType ?? this.salaryType,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      hasPrivatePension: hasPrivatePension ?? this.hasPrivatePension,
      pensionAmount: pensionAmount ?? this.pensionAmount,
      hasMealAllowance: hasMealAllowance ?? this.hasMealAllowance,
      mealAmount: mealAmount ?? this.mealAmount,
      hasTransportAllowance:
          hasTransportAllowance ?? this.hasTransportAllowance,
      transportAmount: transportAmount ?? this.transportAmount,
      hasBonus: hasBonus ?? this.hasBonus,
      bonusAmount: bonusAmount ?? this.bonusAmount,
      hasShiftDiff: hasShiftDiff ?? this.hasShiftDiff,
      shiftDiffAmount: shiftDiffAmount ?? this.shiftDiffAmount,
      overtimeWeekday: overtimeWeekday ?? this.overtimeWeekday,
      overtimeWeekend: overtimeWeekend ?? this.overtimeWeekend,
      overtimeNight: overtimeNight ?? this.overtimeNight,
      currency: currency ?? this.currency,
      theme: theme ?? this.theme,
      monthlyWorkHours: monthlyWorkHours ?? this.monthlyWorkHours,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workType.present) {
      map['work_type'] = Variable<String>(workType.value);
    }
    if (weeklyHours.present) {
      map['weekly_hours'] = Variable<String>(weeklyHours.value);
    }
    if (salaryType.present) {
      map['salary_type'] = Variable<String>(salaryType.value);
    }
    if (salaryAmount.present) {
      map['salary_amount'] = Variable<String>(salaryAmount.value);
    }
    if (hasPrivatePension.present) {
      map['has_private_pension'] = Variable<bool>(hasPrivatePension.value);
    }
    if (pensionAmount.present) {
      map['pension_amount'] = Variable<String>(pensionAmount.value);
    }
    if (hasMealAllowance.present) {
      map['has_meal_allowance'] = Variable<bool>(hasMealAllowance.value);
    }
    if (mealAmount.present) {
      map['meal_amount'] = Variable<String>(mealAmount.value);
    }
    if (hasTransportAllowance.present) {
      map['has_transport_allowance'] =
          Variable<bool>(hasTransportAllowance.value);
    }
    if (transportAmount.present) {
      map['transport_amount'] = Variable<String>(transportAmount.value);
    }
    if (hasBonus.present) {
      map['has_bonus'] = Variable<bool>(hasBonus.value);
    }
    if (bonusAmount.present) {
      map['bonus_amount'] = Variable<String>(bonusAmount.value);
    }
    if (hasShiftDiff.present) {
      map['has_shift_diff'] = Variable<bool>(hasShiftDiff.value);
    }
    if (shiftDiffAmount.present) {
      map['shift_diff_amount'] = Variable<String>(shiftDiffAmount.value);
    }
    if (overtimeWeekday.present) {
      map['overtime_weekday'] = Variable<String>(overtimeWeekday.value);
    }
    if (overtimeWeekend.present) {
      map['overtime_weekend'] = Variable<String>(overtimeWeekend.value);
    }
    if (overtimeNight.present) {
      map['overtime_night'] = Variable<String>(overtimeNight.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (monthlyWorkHours.present) {
      map['monthly_work_hours'] = Variable<int>(monthlyWorkHours.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('workType: $workType, ')
          ..write('weeklyHours: $weeklyHours, ')
          ..write('salaryType: $salaryType, ')
          ..write('salaryAmount: $salaryAmount, ')
          ..write('hasPrivatePension: $hasPrivatePension, ')
          ..write('pensionAmount: $pensionAmount, ')
          ..write('hasMealAllowance: $hasMealAllowance, ')
          ..write('mealAmount: $mealAmount, ')
          ..write('hasTransportAllowance: $hasTransportAllowance, ')
          ..write('transportAmount: $transportAmount, ')
          ..write('hasBonus: $hasBonus, ')
          ..write('bonusAmount: $bonusAmount, ')
          ..write('hasShiftDiff: $hasShiftDiff, ')
          ..write('shiftDiffAmount: $shiftDiffAmount, ')
          ..write('overtimeWeekday: $overtimeWeekday, ')
          ..write('overtimeWeekend: $overtimeWeekend, ')
          ..write('overtimeNight: $overtimeNight, ')
          ..write('currency: $currency, ')
          ..write('theme: $theme, ')
          ..write('monthlyWorkHours: $monthlyWorkHours')
          ..write(')'))
        .toString();
  }
}

class $UserSalaryTableTable extends UserSalaryTable
    with TableInfo<$UserSalaryTableTable, UserSalaryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSalaryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _monthlyBrutMeta =
      const VerificationMeta('monthlyBrut');
  @override
  late final GeneratedColumn<double> monthlyBrut = GeneratedColumn<double>(
      'monthly_brut', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _monthlyNetMeta =
      const VerificationMeta('monthlyNet');
  @override
  late final GeneratedColumn<double> monthlyNet = GeneratedColumn<double>(
      'monthly_net', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sgkIsciMeta =
      const VerificationMeta('sgkIsci');
  @override
  late final GeneratedColumn<double> sgkIsci = GeneratedColumn<double>(
      'sgk_isci', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _issizlikIsciMeta =
      const VerificationMeta('issizlikIsci');
  @override
  late final GeneratedColumn<double> issizlikIsci = GeneratedColumn<double>(
      'issizlik_isci', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sgkIsverenMeta =
      const VerificationMeta('sgkIsveren');
  @override
  late final GeneratedColumn<double> sgkIsveren = GeneratedColumn<double>(
      'sgk_isveren', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _issizlikIsverenMeta =
      const VerificationMeta('issizlikIsveren');
  @override
  late final GeneratedColumn<double> issizlikIsveren = GeneratedColumn<double>(
      'issizlik_isveren', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _damgaMeta = const VerificationMeta('damga');
  @override
  late final GeneratedColumn<double> damga = GeneratedColumn<double>(
      'damga', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gvDilimiMeta =
      const VerificationMeta('gvDilimi');
  @override
  late final GeneratedColumn<double> gvDilimi = GeneratedColumn<double>(
      'gv_dilimi', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _kumulatifMatrahMeta =
      const VerificationMeta('kumulatifMatrah');
  @override
  late final GeneratedColumn<double> kumulatifMatrah = GeneratedColumn<double>(
      'kumulatif_matrah', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hourlyRateNetMeta =
      const VerificationMeta('hourlyRateNet');
  @override
  late final GeneratedColumn<double> hourlyRateNet = GeneratedColumn<double>(
      'hourly_rate_net', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hourlyRateBrutMeta =
      const VerificationMeta('hourlyRateBrut');
  @override
  late final GeneratedColumn<double> hourlyRateBrut = GeneratedColumn<double>(
      'hourly_rate_brut', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        monthlyBrut,
        monthlyNet,
        sgkIsci,
        issizlikIsci,
        sgkIsveren,
        issizlikIsveren,
        damga,
        gvDilimi,
        kumulatifMatrah,
        hourlyRateNet,
        hourlyRateBrut
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_salary_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserSalaryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monthly_brut')) {
      context.handle(
          _monthlyBrutMeta,
          monthlyBrut.isAcceptableOrUnknown(
              data['monthly_brut']!, _monthlyBrutMeta));
    } else if (isInserting) {
      context.missing(_monthlyBrutMeta);
    }
    if (data.containsKey('monthly_net')) {
      context.handle(
          _monthlyNetMeta,
          monthlyNet.isAcceptableOrUnknown(
              data['monthly_net']!, _monthlyNetMeta));
    } else if (isInserting) {
      context.missing(_monthlyNetMeta);
    }
    if (data.containsKey('sgk_isci')) {
      context.handle(_sgkIsciMeta,
          sgkIsci.isAcceptableOrUnknown(data['sgk_isci']!, _sgkIsciMeta));
    } else if (isInserting) {
      context.missing(_sgkIsciMeta);
    }
    if (data.containsKey('issizlik_isci')) {
      context.handle(
          _issizlikIsciMeta,
          issizlikIsci.isAcceptableOrUnknown(
              data['issizlik_isci']!, _issizlikIsciMeta));
    } else if (isInserting) {
      context.missing(_issizlikIsciMeta);
    }
    if (data.containsKey('sgk_isveren')) {
      context.handle(
          _sgkIsverenMeta,
          sgkIsveren.isAcceptableOrUnknown(
              data['sgk_isveren']!, _sgkIsverenMeta));
    } else if (isInserting) {
      context.missing(_sgkIsverenMeta);
    }
    if (data.containsKey('issizlik_isveren')) {
      context.handle(
          _issizlikIsverenMeta,
          issizlikIsveren.isAcceptableOrUnknown(
              data['issizlik_isveren']!, _issizlikIsverenMeta));
    } else if (isInserting) {
      context.missing(_issizlikIsverenMeta);
    }
    if (data.containsKey('damga')) {
      context.handle(
          _damgaMeta, damga.isAcceptableOrUnknown(data['damga']!, _damgaMeta));
    } else if (isInserting) {
      context.missing(_damgaMeta);
    }
    if (data.containsKey('gv_dilimi')) {
      context.handle(_gvDilimiMeta,
          gvDilimi.isAcceptableOrUnknown(data['gv_dilimi']!, _gvDilimiMeta));
    } else if (isInserting) {
      context.missing(_gvDilimiMeta);
    }
    if (data.containsKey('kumulatif_matrah')) {
      context.handle(
          _kumulatifMatrahMeta,
          kumulatifMatrah.isAcceptableOrUnknown(
              data['kumulatif_matrah']!, _kumulatifMatrahMeta));
    } else if (isInserting) {
      context.missing(_kumulatifMatrahMeta);
    }
    if (data.containsKey('hourly_rate_net')) {
      context.handle(
          _hourlyRateNetMeta,
          hourlyRateNet.isAcceptableOrUnknown(
              data['hourly_rate_net']!, _hourlyRateNetMeta));
    }
    if (data.containsKey('hourly_rate_brut')) {
      context.handle(
          _hourlyRateBrutMeta,
          hourlyRateBrut.isAcceptableOrUnknown(
              data['hourly_rate_brut']!, _hourlyRateBrutMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSalaryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSalaryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      monthlyBrut: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_brut'])!,
      monthlyNet: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_net'])!,
      sgkIsci: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sgk_isci'])!,
      issizlikIsci: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}issizlik_isci'])!,
      sgkIsveren: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sgk_isveren'])!,
      issizlikIsveren: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}issizlik_isveren'])!,
      damga: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}damga'])!,
      gvDilimi: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gv_dilimi'])!,
      kumulatifMatrah: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}kumulatif_matrah'])!,
      hourlyRateNet: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}hourly_rate_net'])!,
      hourlyRateBrut: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}hourly_rate_brut'])!,
    );
  }

  @override
  $UserSalaryTableTable createAlias(String alias) {
    return $UserSalaryTableTable(attachedDatabase, alias);
  }
}

class UserSalaryTableData extends DataClass
    implements Insertable<UserSalaryTableData> {
  final int id;
  final double monthlyBrut;
  final double monthlyNet;
  final double sgkIsci;
  final double issizlikIsci;
  final double sgkIsveren;
  final double issizlikIsveren;
  final double damga;
  final double gvDilimi;
  final double kumulatifMatrah;
  final double hourlyRateNet;
  final double hourlyRateBrut;
  const UserSalaryTableData(
      {required this.id,
      required this.monthlyBrut,
      required this.monthlyNet,
      required this.sgkIsci,
      required this.issizlikIsci,
      required this.sgkIsveren,
      required this.issizlikIsveren,
      required this.damga,
      required this.gvDilimi,
      required this.kumulatifMatrah,
      required this.hourlyRateNet,
      required this.hourlyRateBrut});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['monthly_brut'] = Variable<double>(monthlyBrut);
    map['monthly_net'] = Variable<double>(monthlyNet);
    map['sgk_isci'] = Variable<double>(sgkIsci);
    map['issizlik_isci'] = Variable<double>(issizlikIsci);
    map['sgk_isveren'] = Variable<double>(sgkIsveren);
    map['issizlik_isveren'] = Variable<double>(issizlikIsveren);
    map['damga'] = Variable<double>(damga);
    map['gv_dilimi'] = Variable<double>(gvDilimi);
    map['kumulatif_matrah'] = Variable<double>(kumulatifMatrah);
    map['hourly_rate_net'] = Variable<double>(hourlyRateNet);
    map['hourly_rate_brut'] = Variable<double>(hourlyRateBrut);
    return map;
  }

  UserSalaryTableCompanion toCompanion(bool nullToAbsent) {
    return UserSalaryTableCompanion(
      id: Value(id),
      monthlyBrut: Value(monthlyBrut),
      monthlyNet: Value(monthlyNet),
      sgkIsci: Value(sgkIsci),
      issizlikIsci: Value(issizlikIsci),
      sgkIsveren: Value(sgkIsveren),
      issizlikIsveren: Value(issizlikIsveren),
      damga: Value(damga),
      gvDilimi: Value(gvDilimi),
      kumulatifMatrah: Value(kumulatifMatrah),
      hourlyRateNet: Value(hourlyRateNet),
      hourlyRateBrut: Value(hourlyRateBrut),
    );
  }

  factory UserSalaryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSalaryTableData(
      id: serializer.fromJson<int>(json['id']),
      monthlyBrut: serializer.fromJson<double>(json['monthlyBrut']),
      monthlyNet: serializer.fromJson<double>(json['monthlyNet']),
      sgkIsci: serializer.fromJson<double>(json['sgkIsci']),
      issizlikIsci: serializer.fromJson<double>(json['issizlikIsci']),
      sgkIsveren: serializer.fromJson<double>(json['sgkIsveren']),
      issizlikIsveren: serializer.fromJson<double>(json['issizlikIsveren']),
      damga: serializer.fromJson<double>(json['damga']),
      gvDilimi: serializer.fromJson<double>(json['gvDilimi']),
      kumulatifMatrah: serializer.fromJson<double>(json['kumulatifMatrah']),
      hourlyRateNet: serializer.fromJson<double>(json['hourlyRateNet']),
      hourlyRateBrut: serializer.fromJson<double>(json['hourlyRateBrut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthlyBrut': serializer.toJson<double>(monthlyBrut),
      'monthlyNet': serializer.toJson<double>(monthlyNet),
      'sgkIsci': serializer.toJson<double>(sgkIsci),
      'issizlikIsci': serializer.toJson<double>(issizlikIsci),
      'sgkIsveren': serializer.toJson<double>(sgkIsveren),
      'issizlikIsveren': serializer.toJson<double>(issizlikIsveren),
      'damga': serializer.toJson<double>(damga),
      'gvDilimi': serializer.toJson<double>(gvDilimi),
      'kumulatifMatrah': serializer.toJson<double>(kumulatifMatrah),
      'hourlyRateNet': serializer.toJson<double>(hourlyRateNet),
      'hourlyRateBrut': serializer.toJson<double>(hourlyRateBrut),
    };
  }

  UserSalaryTableData copyWith(
          {int? id,
          double? monthlyBrut,
          double? monthlyNet,
          double? sgkIsci,
          double? issizlikIsci,
          double? sgkIsveren,
          double? issizlikIsveren,
          double? damga,
          double? gvDilimi,
          double? kumulatifMatrah,
          double? hourlyRateNet,
          double? hourlyRateBrut}) =>
      UserSalaryTableData(
        id: id ?? this.id,
        monthlyBrut: monthlyBrut ?? this.monthlyBrut,
        monthlyNet: monthlyNet ?? this.monthlyNet,
        sgkIsci: sgkIsci ?? this.sgkIsci,
        issizlikIsci: issizlikIsci ?? this.issizlikIsci,
        sgkIsveren: sgkIsveren ?? this.sgkIsveren,
        issizlikIsveren: issizlikIsveren ?? this.issizlikIsveren,
        damga: damga ?? this.damga,
        gvDilimi: gvDilimi ?? this.gvDilimi,
        kumulatifMatrah: kumulatifMatrah ?? this.kumulatifMatrah,
        hourlyRateNet: hourlyRateNet ?? this.hourlyRateNet,
        hourlyRateBrut: hourlyRateBrut ?? this.hourlyRateBrut,
      );
  UserSalaryTableData copyWithCompanion(UserSalaryTableCompanion data) {
    return UserSalaryTableData(
      id: data.id.present ? data.id.value : this.id,
      monthlyBrut:
          data.monthlyBrut.present ? data.monthlyBrut.value : this.monthlyBrut,
      monthlyNet:
          data.monthlyNet.present ? data.monthlyNet.value : this.monthlyNet,
      sgkIsci: data.sgkIsci.present ? data.sgkIsci.value : this.sgkIsci,
      issizlikIsci: data.issizlikIsci.present
          ? data.issizlikIsci.value
          : this.issizlikIsci,
      sgkIsveren:
          data.sgkIsveren.present ? data.sgkIsveren.value : this.sgkIsveren,
      issizlikIsveren: data.issizlikIsveren.present
          ? data.issizlikIsveren.value
          : this.issizlikIsveren,
      damga: data.damga.present ? data.damga.value : this.damga,
      gvDilimi: data.gvDilimi.present ? data.gvDilimi.value : this.gvDilimi,
      kumulatifMatrah: data.kumulatifMatrah.present
          ? data.kumulatifMatrah.value
          : this.kumulatifMatrah,
      hourlyRateNet: data.hourlyRateNet.present
          ? data.hourlyRateNet.value
          : this.hourlyRateNet,
      hourlyRateBrut: data.hourlyRateBrut.present
          ? data.hourlyRateBrut.value
          : this.hourlyRateBrut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSalaryTableData(')
          ..write('id: $id, ')
          ..write('monthlyBrut: $monthlyBrut, ')
          ..write('monthlyNet: $monthlyNet, ')
          ..write('sgkIsci: $sgkIsci, ')
          ..write('issizlikIsci: $issizlikIsci, ')
          ..write('sgkIsveren: $sgkIsveren, ')
          ..write('issizlikIsveren: $issizlikIsveren, ')
          ..write('damga: $damga, ')
          ..write('gvDilimi: $gvDilimi, ')
          ..write('kumulatifMatrah: $kumulatifMatrah, ')
          ..write('hourlyRateNet: $hourlyRateNet, ')
          ..write('hourlyRateBrut: $hourlyRateBrut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      monthlyBrut,
      monthlyNet,
      sgkIsci,
      issizlikIsci,
      sgkIsveren,
      issizlikIsveren,
      damga,
      gvDilimi,
      kumulatifMatrah,
      hourlyRateNet,
      hourlyRateBrut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSalaryTableData &&
          other.id == this.id &&
          other.monthlyBrut == this.monthlyBrut &&
          other.monthlyNet == this.monthlyNet &&
          other.sgkIsci == this.sgkIsci &&
          other.issizlikIsci == this.issizlikIsci &&
          other.sgkIsveren == this.sgkIsveren &&
          other.issizlikIsveren == this.issizlikIsveren &&
          other.damga == this.damga &&
          other.gvDilimi == this.gvDilimi &&
          other.kumulatifMatrah == this.kumulatifMatrah &&
          other.hourlyRateNet == this.hourlyRateNet &&
          other.hourlyRateBrut == this.hourlyRateBrut);
}

class UserSalaryTableCompanion extends UpdateCompanion<UserSalaryTableData> {
  final Value<int> id;
  final Value<double> monthlyBrut;
  final Value<double> monthlyNet;
  final Value<double> sgkIsci;
  final Value<double> issizlikIsci;
  final Value<double> sgkIsveren;
  final Value<double> issizlikIsveren;
  final Value<double> damga;
  final Value<double> gvDilimi;
  final Value<double> kumulatifMatrah;
  final Value<double> hourlyRateNet;
  final Value<double> hourlyRateBrut;
  const UserSalaryTableCompanion({
    this.id = const Value.absent(),
    this.monthlyBrut = const Value.absent(),
    this.monthlyNet = const Value.absent(),
    this.sgkIsci = const Value.absent(),
    this.issizlikIsci = const Value.absent(),
    this.sgkIsveren = const Value.absent(),
    this.issizlikIsveren = const Value.absent(),
    this.damga = const Value.absent(),
    this.gvDilimi = const Value.absent(),
    this.kumulatifMatrah = const Value.absent(),
    this.hourlyRateNet = const Value.absent(),
    this.hourlyRateBrut = const Value.absent(),
  });
  UserSalaryTableCompanion.insert({
    this.id = const Value.absent(),
    required double monthlyBrut,
    required double monthlyNet,
    required double sgkIsci,
    required double issizlikIsci,
    required double sgkIsveren,
    required double issizlikIsveren,
    required double damga,
    required double gvDilimi,
    required double kumulatifMatrah,
    this.hourlyRateNet = const Value.absent(),
    this.hourlyRateBrut = const Value.absent(),
  })  : monthlyBrut = Value(monthlyBrut),
        monthlyNet = Value(monthlyNet),
        sgkIsci = Value(sgkIsci),
        issizlikIsci = Value(issizlikIsci),
        sgkIsveren = Value(sgkIsveren),
        issizlikIsveren = Value(issizlikIsveren),
        damga = Value(damga),
        gvDilimi = Value(gvDilimi),
        kumulatifMatrah = Value(kumulatifMatrah);
  static Insertable<UserSalaryTableData> custom({
    Expression<int>? id,
    Expression<double>? monthlyBrut,
    Expression<double>? monthlyNet,
    Expression<double>? sgkIsci,
    Expression<double>? issizlikIsci,
    Expression<double>? sgkIsveren,
    Expression<double>? issizlikIsveren,
    Expression<double>? damga,
    Expression<double>? gvDilimi,
    Expression<double>? kumulatifMatrah,
    Expression<double>? hourlyRateNet,
    Expression<double>? hourlyRateBrut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthlyBrut != null) 'monthly_brut': monthlyBrut,
      if (monthlyNet != null) 'monthly_net': monthlyNet,
      if (sgkIsci != null) 'sgk_isci': sgkIsci,
      if (issizlikIsci != null) 'issizlik_isci': issizlikIsci,
      if (sgkIsveren != null) 'sgk_isveren': sgkIsveren,
      if (issizlikIsveren != null) 'issizlik_isveren': issizlikIsveren,
      if (damga != null) 'damga': damga,
      if (gvDilimi != null) 'gv_dilimi': gvDilimi,
      if (kumulatifMatrah != null) 'kumulatif_matrah': kumulatifMatrah,
      if (hourlyRateNet != null) 'hourly_rate_net': hourlyRateNet,
      if (hourlyRateBrut != null) 'hourly_rate_brut': hourlyRateBrut,
    });
  }

  UserSalaryTableCompanion copyWith(
      {Value<int>? id,
      Value<double>? monthlyBrut,
      Value<double>? monthlyNet,
      Value<double>? sgkIsci,
      Value<double>? issizlikIsci,
      Value<double>? sgkIsveren,
      Value<double>? issizlikIsveren,
      Value<double>? damga,
      Value<double>? gvDilimi,
      Value<double>? kumulatifMatrah,
      Value<double>? hourlyRateNet,
      Value<double>? hourlyRateBrut}) {
    return UserSalaryTableCompanion(
      id: id ?? this.id,
      monthlyBrut: monthlyBrut ?? this.monthlyBrut,
      monthlyNet: monthlyNet ?? this.monthlyNet,
      sgkIsci: sgkIsci ?? this.sgkIsci,
      issizlikIsci: issizlikIsci ?? this.issizlikIsci,
      sgkIsveren: sgkIsveren ?? this.sgkIsveren,
      issizlikIsveren: issizlikIsveren ?? this.issizlikIsveren,
      damga: damga ?? this.damga,
      gvDilimi: gvDilimi ?? this.gvDilimi,
      kumulatifMatrah: kumulatifMatrah ?? this.kumulatifMatrah,
      hourlyRateNet: hourlyRateNet ?? this.hourlyRateNet,
      hourlyRateBrut: hourlyRateBrut ?? this.hourlyRateBrut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthlyBrut.present) {
      map['monthly_brut'] = Variable<double>(monthlyBrut.value);
    }
    if (monthlyNet.present) {
      map['monthly_net'] = Variable<double>(monthlyNet.value);
    }
    if (sgkIsci.present) {
      map['sgk_isci'] = Variable<double>(sgkIsci.value);
    }
    if (issizlikIsci.present) {
      map['issizlik_isci'] = Variable<double>(issizlikIsci.value);
    }
    if (sgkIsveren.present) {
      map['sgk_isveren'] = Variable<double>(sgkIsveren.value);
    }
    if (issizlikIsveren.present) {
      map['issizlik_isveren'] = Variable<double>(issizlikIsveren.value);
    }
    if (damga.present) {
      map['damga'] = Variable<double>(damga.value);
    }
    if (gvDilimi.present) {
      map['gv_dilimi'] = Variable<double>(gvDilimi.value);
    }
    if (kumulatifMatrah.present) {
      map['kumulatif_matrah'] = Variable<double>(kumulatifMatrah.value);
    }
    if (hourlyRateNet.present) {
      map['hourly_rate_net'] = Variable<double>(hourlyRateNet.value);
    }
    if (hourlyRateBrut.present) {
      map['hourly_rate_brut'] = Variable<double>(hourlyRateBrut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSalaryTableCompanion(')
          ..write('id: $id, ')
          ..write('monthlyBrut: $monthlyBrut, ')
          ..write('monthlyNet: $monthlyNet, ')
          ..write('sgkIsci: $sgkIsci, ')
          ..write('issizlikIsci: $issizlikIsci, ')
          ..write('sgkIsveren: $sgkIsveren, ')
          ..write('issizlikIsveren: $issizlikIsveren, ')
          ..write('damga: $damga, ')
          ..write('gvDilimi: $gvDilimi, ')
          ..write('kumulatifMatrah: $kumulatifMatrah, ')
          ..write('hourlyRateNet: $hourlyRateNet, ')
          ..write('hourlyRateBrut: $hourlyRateBrut')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MesaiTableTable mesaiTable = $MesaiTableTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $UserSalaryTableTable userSalaryTable =
      $UserSalaryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [mesaiTable, userSettingsTable, userSalaryTable];
}

typedef $$MesaiTableTableCreateCompanionBuilder = MesaiTableCompanion Function({
  Value<int> id,
  required DateTime tarih,
  required double saat,
  required double ucret,
  Value<double> carpan,
  Value<String?> aciklama,
});
typedef $$MesaiTableTableUpdateCompanionBuilder = MesaiTableCompanion Function({
  Value<int> id,
  Value<DateTime> tarih,
  Value<double> saat,
  Value<double> ucret,
  Value<double> carpan,
  Value<String?> aciklama,
});

class $$MesaiTableTableFilterComposer
    extends Composer<_$AppDatabase, $MesaiTableTable> {
  $$MesaiTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tarih => $composableBuilder(
      column: $table.tarih, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get saat => $composableBuilder(
      column: $table.saat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ucret => $composableBuilder(
      column: $table.ucret, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carpan => $composableBuilder(
      column: $table.carpan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aciklama => $composableBuilder(
      column: $table.aciklama, builder: (column) => ColumnFilters(column));
}

class $$MesaiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MesaiTableTable> {
  $$MesaiTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tarih => $composableBuilder(
      column: $table.tarih, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get saat => $composableBuilder(
      column: $table.saat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ucret => $composableBuilder(
      column: $table.ucret, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carpan => $composableBuilder(
      column: $table.carpan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aciklama => $composableBuilder(
      column: $table.aciklama, builder: (column) => ColumnOrderings(column));
}

class $$MesaiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MesaiTableTable> {
  $$MesaiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get tarih =>
      $composableBuilder(column: $table.tarih, builder: (column) => column);

  GeneratedColumn<double> get saat =>
      $composableBuilder(column: $table.saat, builder: (column) => column);

  GeneratedColumn<double> get ucret =>
      $composableBuilder(column: $table.ucret, builder: (column) => column);

  GeneratedColumn<double> get carpan =>
      $composableBuilder(column: $table.carpan, builder: (column) => column);

  GeneratedColumn<String> get aciklama =>
      $composableBuilder(column: $table.aciklama, builder: (column) => column);
}

class $$MesaiTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MesaiTableTable,
    MesaiTableData,
    $$MesaiTableTableFilterComposer,
    $$MesaiTableTableOrderingComposer,
    $$MesaiTableTableAnnotationComposer,
    $$MesaiTableTableCreateCompanionBuilder,
    $$MesaiTableTableUpdateCompanionBuilder,
    (
      MesaiTableData,
      BaseReferences<_$AppDatabase, $MesaiTableTable, MesaiTableData>
    ),
    MesaiTableData,
    PrefetchHooks Function()> {
  $$MesaiTableTableTableManager(_$AppDatabase db, $MesaiTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MesaiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MesaiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MesaiTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> tarih = const Value.absent(),
            Value<double> saat = const Value.absent(),
            Value<double> ucret = const Value.absent(),
            Value<double> carpan = const Value.absent(),
            Value<String?> aciklama = const Value.absent(),
          }) =>
              MesaiTableCompanion(
            id: id,
            tarih: tarih,
            saat: saat,
            ucret: ucret,
            carpan: carpan,
            aciklama: aciklama,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime tarih,
            required double saat,
            required double ucret,
            Value<double> carpan = const Value.absent(),
            Value<String?> aciklama = const Value.absent(),
          }) =>
              MesaiTableCompanion.insert(
            id: id,
            tarih: tarih,
            saat: saat,
            ucret: ucret,
            carpan: carpan,
            aciklama: aciklama,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MesaiTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MesaiTableTable,
    MesaiTableData,
    $$MesaiTableTableFilterComposer,
    $$MesaiTableTableOrderingComposer,
    $$MesaiTableTableAnnotationComposer,
    $$MesaiTableTableCreateCompanionBuilder,
    $$MesaiTableTableUpdateCompanionBuilder,
    (
      MesaiTableData,
      BaseReferences<_$AppDatabase, $MesaiTableTable, MesaiTableData>
    ),
    MesaiTableData,
    PrefetchHooks Function()>;
typedef $$UserSettingsTableTableCreateCompanionBuilder
    = UserSettingsTableCompanion Function({
  Value<int> id,
  Value<String> workType,
  Value<String> weeklyHours,
  Value<String> salaryType,
  Value<String> salaryAmount,
  Value<bool> hasPrivatePension,
  Value<String> pensionAmount,
  Value<bool> hasMealAllowance,
  Value<String> mealAmount,
  Value<bool> hasTransportAllowance,
  Value<String> transportAmount,
  Value<bool> hasBonus,
  Value<String> bonusAmount,
  Value<bool> hasShiftDiff,
  Value<String> shiftDiffAmount,
  Value<String> overtimeWeekday,
  Value<String> overtimeWeekend,
  Value<String> overtimeNight,
  Value<String> currency,
  Value<String> theme,
  Value<int> monthlyWorkHours,
});
typedef $$UserSettingsTableTableUpdateCompanionBuilder
    = UserSettingsTableCompanion Function({
  Value<int> id,
  Value<String> workType,
  Value<String> weeklyHours,
  Value<String> salaryType,
  Value<String> salaryAmount,
  Value<bool> hasPrivatePension,
  Value<String> pensionAmount,
  Value<bool> hasMealAllowance,
  Value<String> mealAmount,
  Value<bool> hasTransportAllowance,
  Value<String> transportAmount,
  Value<bool> hasBonus,
  Value<String> bonusAmount,
  Value<bool> hasShiftDiff,
  Value<String> shiftDiffAmount,
  Value<String> overtimeWeekday,
  Value<String> overtimeWeekend,
  Value<String> overtimeNight,
  Value<String> currency,
  Value<String> theme,
  Value<int> monthlyWorkHours,
});

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workType => $composableBuilder(
      column: $table.workType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weeklyHours => $composableBuilder(
      column: $table.weeklyHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salaryAmount => $composableBuilder(
      column: $table.salaryAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasPrivatePension => $composableBuilder(
      column: $table.hasPrivatePension,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pensionAmount => $composableBuilder(
      column: $table.pensionAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasMealAllowance => $composableBuilder(
      column: $table.hasMealAllowance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealAmount => $composableBuilder(
      column: $table.mealAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasTransportAllowance => $composableBuilder(
      column: $table.hasTransportAllowance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transportAmount => $composableBuilder(
      column: $table.transportAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasBonus => $composableBuilder(
      column: $table.hasBonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bonusAmount => $composableBuilder(
      column: $table.bonusAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasShiftDiff => $composableBuilder(
      column: $table.hasShiftDiff, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shiftDiffAmount => $composableBuilder(
      column: $table.shiftDiffAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overtimeWeekday => $composableBuilder(
      column: $table.overtimeWeekday,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overtimeWeekend => $composableBuilder(
      column: $table.overtimeWeekend,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overtimeNight => $composableBuilder(
      column: $table.overtimeNight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthlyWorkHours => $composableBuilder(
      column: $table.monthlyWorkHours,
      builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workType => $composableBuilder(
      column: $table.workType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weeklyHours => $composableBuilder(
      column: $table.weeklyHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salaryAmount => $composableBuilder(
      column: $table.salaryAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasPrivatePension => $composableBuilder(
      column: $table.hasPrivatePension,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pensionAmount => $composableBuilder(
      column: $table.pensionAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasMealAllowance => $composableBuilder(
      column: $table.hasMealAllowance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealAmount => $composableBuilder(
      column: $table.mealAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasTransportAllowance => $composableBuilder(
      column: $table.hasTransportAllowance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transportAmount => $composableBuilder(
      column: $table.transportAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasBonus => $composableBuilder(
      column: $table.hasBonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bonusAmount => $composableBuilder(
      column: $table.bonusAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasShiftDiff => $composableBuilder(
      column: $table.hasShiftDiff,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shiftDiffAmount => $composableBuilder(
      column: $table.shiftDiffAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overtimeWeekday => $composableBuilder(
      column: $table.overtimeWeekday,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overtimeWeekend => $composableBuilder(
      column: $table.overtimeWeekend,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overtimeNight => $composableBuilder(
      column: $table.overtimeNight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthlyWorkHours => $composableBuilder(
      column: $table.monthlyWorkHours,
      builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workType =>
      $composableBuilder(column: $table.workType, builder: (column) => column);

  GeneratedColumn<String> get weeklyHours => $composableBuilder(
      column: $table.weeklyHours, builder: (column) => column);

  GeneratedColumn<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => column);

  GeneratedColumn<String> get salaryAmount => $composableBuilder(
      column: $table.salaryAmount, builder: (column) => column);

  GeneratedColumn<bool> get hasPrivatePension => $composableBuilder(
      column: $table.hasPrivatePension, builder: (column) => column);

  GeneratedColumn<String> get pensionAmount => $composableBuilder(
      column: $table.pensionAmount, builder: (column) => column);

  GeneratedColumn<bool> get hasMealAllowance => $composableBuilder(
      column: $table.hasMealAllowance, builder: (column) => column);

  GeneratedColumn<String> get mealAmount => $composableBuilder(
      column: $table.mealAmount, builder: (column) => column);

  GeneratedColumn<bool> get hasTransportAllowance => $composableBuilder(
      column: $table.hasTransportAllowance, builder: (column) => column);

  GeneratedColumn<String> get transportAmount => $composableBuilder(
      column: $table.transportAmount, builder: (column) => column);

  GeneratedColumn<bool> get hasBonus =>
      $composableBuilder(column: $table.hasBonus, builder: (column) => column);

  GeneratedColumn<String> get bonusAmount => $composableBuilder(
      column: $table.bonusAmount, builder: (column) => column);

  GeneratedColumn<bool> get hasShiftDiff => $composableBuilder(
      column: $table.hasShiftDiff, builder: (column) => column);

  GeneratedColumn<String> get shiftDiffAmount => $composableBuilder(
      column: $table.shiftDiffAmount, builder: (column) => column);

  GeneratedColumn<String> get overtimeWeekday => $composableBuilder(
      column: $table.overtimeWeekday, builder: (column) => column);

  GeneratedColumn<String> get overtimeWeekend => $composableBuilder(
      column: $table.overtimeWeekend, builder: (column) => column);

  GeneratedColumn<String> get overtimeNight => $composableBuilder(
      column: $table.overtimeNight, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<int> get monthlyWorkHours => $composableBuilder(
      column: $table.monthlyWorkHours, builder: (column) => column);
}

class $$UserSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTableTable,
    UserSettingsTableData,
    $$UserSettingsTableTableFilterComposer,
    $$UserSettingsTableTableOrderingComposer,
    $$UserSettingsTableTableAnnotationComposer,
    $$UserSettingsTableTableCreateCompanionBuilder,
    $$UserSettingsTableTableUpdateCompanionBuilder,
    (
      UserSettingsTableData,
      BaseReferences<_$AppDatabase, $UserSettingsTableTable,
          UserSettingsTableData>
    ),
    UserSettingsTableData,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableTableManager(
      _$AppDatabase db, $UserSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> workType = const Value.absent(),
            Value<String> weeklyHours = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<String> salaryAmount = const Value.absent(),
            Value<bool> hasPrivatePension = const Value.absent(),
            Value<String> pensionAmount = const Value.absent(),
            Value<bool> hasMealAllowance = const Value.absent(),
            Value<String> mealAmount = const Value.absent(),
            Value<bool> hasTransportAllowance = const Value.absent(),
            Value<String> transportAmount = const Value.absent(),
            Value<bool> hasBonus = const Value.absent(),
            Value<String> bonusAmount = const Value.absent(),
            Value<bool> hasShiftDiff = const Value.absent(),
            Value<String> shiftDiffAmount = const Value.absent(),
            Value<String> overtimeWeekday = const Value.absent(),
            Value<String> overtimeWeekend = const Value.absent(),
            Value<String> overtimeNight = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<int> monthlyWorkHours = const Value.absent(),
          }) =>
              UserSettingsTableCompanion(
            id: id,
            workType: workType,
            weeklyHours: weeklyHours,
            salaryType: salaryType,
            salaryAmount: salaryAmount,
            hasPrivatePension: hasPrivatePension,
            pensionAmount: pensionAmount,
            hasMealAllowance: hasMealAllowance,
            mealAmount: mealAmount,
            hasTransportAllowance: hasTransportAllowance,
            transportAmount: transportAmount,
            hasBonus: hasBonus,
            bonusAmount: bonusAmount,
            hasShiftDiff: hasShiftDiff,
            shiftDiffAmount: shiftDiffAmount,
            overtimeWeekday: overtimeWeekday,
            overtimeWeekend: overtimeWeekend,
            overtimeNight: overtimeNight,
            currency: currency,
            theme: theme,
            monthlyWorkHours: monthlyWorkHours,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> workType = const Value.absent(),
            Value<String> weeklyHours = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<String> salaryAmount = const Value.absent(),
            Value<bool> hasPrivatePension = const Value.absent(),
            Value<String> pensionAmount = const Value.absent(),
            Value<bool> hasMealAllowance = const Value.absent(),
            Value<String> mealAmount = const Value.absent(),
            Value<bool> hasTransportAllowance = const Value.absent(),
            Value<String> transportAmount = const Value.absent(),
            Value<bool> hasBonus = const Value.absent(),
            Value<String> bonusAmount = const Value.absent(),
            Value<bool> hasShiftDiff = const Value.absent(),
            Value<String> shiftDiffAmount = const Value.absent(),
            Value<String> overtimeWeekday = const Value.absent(),
            Value<String> overtimeWeekend = const Value.absent(),
            Value<String> overtimeNight = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<int> monthlyWorkHours = const Value.absent(),
          }) =>
              UserSettingsTableCompanion.insert(
            id: id,
            workType: workType,
            weeklyHours: weeklyHours,
            salaryType: salaryType,
            salaryAmount: salaryAmount,
            hasPrivatePension: hasPrivatePension,
            pensionAmount: pensionAmount,
            hasMealAllowance: hasMealAllowance,
            mealAmount: mealAmount,
            hasTransportAllowance: hasTransportAllowance,
            transportAmount: transportAmount,
            hasBonus: hasBonus,
            bonusAmount: bonusAmount,
            hasShiftDiff: hasShiftDiff,
            shiftDiffAmount: shiftDiffAmount,
            overtimeWeekday: overtimeWeekday,
            overtimeWeekend: overtimeWeekend,
            overtimeNight: overtimeNight,
            currency: currency,
            theme: theme,
            monthlyWorkHours: monthlyWorkHours,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSettingsTableTable,
    UserSettingsTableData,
    $$UserSettingsTableTableFilterComposer,
    $$UserSettingsTableTableOrderingComposer,
    $$UserSettingsTableTableAnnotationComposer,
    $$UserSettingsTableTableCreateCompanionBuilder,
    $$UserSettingsTableTableUpdateCompanionBuilder,
    (
      UserSettingsTableData,
      BaseReferences<_$AppDatabase, $UserSettingsTableTable,
          UserSettingsTableData>
    ),
    UserSettingsTableData,
    PrefetchHooks Function()>;
typedef $$UserSalaryTableTableCreateCompanionBuilder = UserSalaryTableCompanion
    Function({
  Value<int> id,
  required double monthlyBrut,
  required double monthlyNet,
  required double sgkIsci,
  required double issizlikIsci,
  required double sgkIsveren,
  required double issizlikIsveren,
  required double damga,
  required double gvDilimi,
  required double kumulatifMatrah,
  Value<double> hourlyRateNet,
  Value<double> hourlyRateBrut,
});
typedef $$UserSalaryTableTableUpdateCompanionBuilder = UserSalaryTableCompanion
    Function({
  Value<int> id,
  Value<double> monthlyBrut,
  Value<double> monthlyNet,
  Value<double> sgkIsci,
  Value<double> issizlikIsci,
  Value<double> sgkIsveren,
  Value<double> issizlikIsveren,
  Value<double> damga,
  Value<double> gvDilimi,
  Value<double> kumulatifMatrah,
  Value<double> hourlyRateNet,
  Value<double> hourlyRateBrut,
});

class $$UserSalaryTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSalaryTableTable> {
  $$UserSalaryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlyBrut => $composableBuilder(
      column: $table.monthlyBrut, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlyNet => $composableBuilder(
      column: $table.monthlyNet, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sgkIsci => $composableBuilder(
      column: $table.sgkIsci, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get issizlikIsci => $composableBuilder(
      column: $table.issizlikIsci, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sgkIsveren => $composableBuilder(
      column: $table.sgkIsveren, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get issizlikIsveren => $composableBuilder(
      column: $table.issizlikIsveren,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get damga => $composableBuilder(
      column: $table.damga, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gvDilimi => $composableBuilder(
      column: $table.gvDilimi, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kumulatifMatrah => $composableBuilder(
      column: $table.kumulatifMatrah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hourlyRateNet => $composableBuilder(
      column: $table.hourlyRateNet, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hourlyRateBrut => $composableBuilder(
      column: $table.hourlyRateBrut,
      builder: (column) => ColumnFilters(column));
}

class $$UserSalaryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSalaryTableTable> {
  $$UserSalaryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlyBrut => $composableBuilder(
      column: $table.monthlyBrut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlyNet => $composableBuilder(
      column: $table.monthlyNet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sgkIsci => $composableBuilder(
      column: $table.sgkIsci, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get issizlikIsci => $composableBuilder(
      column: $table.issizlikIsci,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sgkIsveren => $composableBuilder(
      column: $table.sgkIsveren, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get issizlikIsveren => $composableBuilder(
      column: $table.issizlikIsveren,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get damga => $composableBuilder(
      column: $table.damga, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gvDilimi => $composableBuilder(
      column: $table.gvDilimi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kumulatifMatrah => $composableBuilder(
      column: $table.kumulatifMatrah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hourlyRateNet => $composableBuilder(
      column: $table.hourlyRateNet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hourlyRateBrut => $composableBuilder(
      column: $table.hourlyRateBrut,
      builder: (column) => ColumnOrderings(column));
}

class $$UserSalaryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSalaryTableTable> {
  $$UserSalaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monthlyBrut => $composableBuilder(
      column: $table.monthlyBrut, builder: (column) => column);

  GeneratedColumn<double> get monthlyNet => $composableBuilder(
      column: $table.monthlyNet, builder: (column) => column);

  GeneratedColumn<double> get sgkIsci =>
      $composableBuilder(column: $table.sgkIsci, builder: (column) => column);

  GeneratedColumn<double> get issizlikIsci => $composableBuilder(
      column: $table.issizlikIsci, builder: (column) => column);

  GeneratedColumn<double> get sgkIsveren => $composableBuilder(
      column: $table.sgkIsveren, builder: (column) => column);

  GeneratedColumn<double> get issizlikIsveren => $composableBuilder(
      column: $table.issizlikIsveren, builder: (column) => column);

  GeneratedColumn<double> get damga =>
      $composableBuilder(column: $table.damga, builder: (column) => column);

  GeneratedColumn<double> get gvDilimi =>
      $composableBuilder(column: $table.gvDilimi, builder: (column) => column);

  GeneratedColumn<double> get kumulatifMatrah => $composableBuilder(
      column: $table.kumulatifMatrah, builder: (column) => column);

  GeneratedColumn<double> get hourlyRateNet => $composableBuilder(
      column: $table.hourlyRateNet, builder: (column) => column);

  GeneratedColumn<double> get hourlyRateBrut => $composableBuilder(
      column: $table.hourlyRateBrut, builder: (column) => column);
}

class $$UserSalaryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSalaryTableTable,
    UserSalaryTableData,
    $$UserSalaryTableTableFilterComposer,
    $$UserSalaryTableTableOrderingComposer,
    $$UserSalaryTableTableAnnotationComposer,
    $$UserSalaryTableTableCreateCompanionBuilder,
    $$UserSalaryTableTableUpdateCompanionBuilder,
    (
      UserSalaryTableData,
      BaseReferences<_$AppDatabase, $UserSalaryTableTable, UserSalaryTableData>
    ),
    UserSalaryTableData,
    PrefetchHooks Function()> {
  $$UserSalaryTableTableTableManager(
      _$AppDatabase db, $UserSalaryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSalaryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSalaryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSalaryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> monthlyBrut = const Value.absent(),
            Value<double> monthlyNet = const Value.absent(),
            Value<double> sgkIsci = const Value.absent(),
            Value<double> issizlikIsci = const Value.absent(),
            Value<double> sgkIsveren = const Value.absent(),
            Value<double> issizlikIsveren = const Value.absent(),
            Value<double> damga = const Value.absent(),
            Value<double> gvDilimi = const Value.absent(),
            Value<double> kumulatifMatrah = const Value.absent(),
            Value<double> hourlyRateNet = const Value.absent(),
            Value<double> hourlyRateBrut = const Value.absent(),
          }) =>
              UserSalaryTableCompanion(
            id: id,
            monthlyBrut: monthlyBrut,
            monthlyNet: monthlyNet,
            sgkIsci: sgkIsci,
            issizlikIsci: issizlikIsci,
            sgkIsveren: sgkIsveren,
            issizlikIsveren: issizlikIsveren,
            damga: damga,
            gvDilimi: gvDilimi,
            kumulatifMatrah: kumulatifMatrah,
            hourlyRateNet: hourlyRateNet,
            hourlyRateBrut: hourlyRateBrut,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double monthlyBrut,
            required double monthlyNet,
            required double sgkIsci,
            required double issizlikIsci,
            required double sgkIsveren,
            required double issizlikIsveren,
            required double damga,
            required double gvDilimi,
            required double kumulatifMatrah,
            Value<double> hourlyRateNet = const Value.absent(),
            Value<double> hourlyRateBrut = const Value.absent(),
          }) =>
              UserSalaryTableCompanion.insert(
            id: id,
            monthlyBrut: monthlyBrut,
            monthlyNet: monthlyNet,
            sgkIsci: sgkIsci,
            issizlikIsci: issizlikIsci,
            sgkIsveren: sgkIsveren,
            issizlikIsveren: issizlikIsveren,
            damga: damga,
            gvDilimi: gvDilimi,
            kumulatifMatrah: kumulatifMatrah,
            hourlyRateNet: hourlyRateNet,
            hourlyRateBrut: hourlyRateBrut,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSalaryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSalaryTableTable,
    UserSalaryTableData,
    $$UserSalaryTableTableFilterComposer,
    $$UserSalaryTableTableOrderingComposer,
    $$UserSalaryTableTableAnnotationComposer,
    $$UserSalaryTableTableCreateCompanionBuilder,
    $$UserSalaryTableTableUpdateCompanionBuilder,
    (
      UserSalaryTableData,
      BaseReferences<_$AppDatabase, $UserSalaryTableTable, UserSalaryTableData>
    ),
    UserSalaryTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MesaiTableTableTableManager get mesaiTable =>
      $$MesaiTableTableTableManager(_db, _db.mesaiTable);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$UserSalaryTableTableTableManager get userSalaryTable =>
      $$UserSalaryTableTableTableManager(_db, _db.userSalaryTable);
}
