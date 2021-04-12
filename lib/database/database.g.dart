// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class AssetKind extends DataClass implements Insertable<AssetKind> {
  final int id;
  final String name;
  final String color;
  AssetKind({required this.id, required this.name, required this.color});
  factory AssetKind.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return AssetKind(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      color:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}color'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    return map;
  }

  AssetKindTableCompanion toCompanion(bool nullToAbsent) {
    return AssetKindTableCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  factory AssetKind.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AssetKind(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
    };
  }

  AssetKind copyWith({int? id, String? name, String? color}) => AssetKind(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('AssetKind(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, color.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AssetKind &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class AssetKindTableCompanion extends UpdateCompanion<AssetKind> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  const AssetKindTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  AssetKindTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String color,
  })   : name = Value(name),
        color = Value(color);
  static Insertable<AssetKind> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  AssetKindTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? color}) {
    return AssetKindTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetKindTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $AssetKindTableTable extends AssetKindTable
    with TableInfo<$AssetKindTableTable, AssetKind> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AssetKindTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedTextColumn color = _constructColor();
  GeneratedTextColumn _constructColor() {
    return GeneratedTextColumn(
      'color',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  $AssetKindTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'asset_kind_table';
  @override
  final String actualTableName = 'asset_kind_table';
  @override
  VerificationContext validateIntegrity(Insertable<AssetKind> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetKind map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AssetKind.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssetKindTableTable createAlias(String alias) {
    return $AssetKindTableTable(_db, alias);
  }
}

class AssetGroup extends DataClass implements Insertable<AssetGroup> {
  final int id;
  final String name;
  AssetGroup({required this.id, required this.name});
  factory AssetGroup.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return AssetGroup(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  AssetGroupTableCompanion toCompanion(bool nullToAbsent) {
    return AssetGroupTableCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory AssetGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AssetGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  AssetGroup copyWith({int? id, String? name}) => AssetGroup(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('AssetGroup(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AssetGroup && other.id == this.id && other.name == this.name);
}

class AssetGroupTableCompanion extends UpdateCompanion<AssetGroup> {
  final Value<int> id;
  final Value<String> name;
  const AssetGroupTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  AssetGroupTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<AssetGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  AssetGroupTableCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return AssetGroupTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetGroupTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $AssetGroupTableTable extends AssetGroupTable
    with TableInfo<$AssetGroupTableTable, AssetGroup> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AssetGroupTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  $AssetGroupTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'asset_group_table';
  @override
  final String actualTableName = 'asset_group_table';
  @override
  VerificationContext validateIntegrity(Insertable<AssetGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AssetGroup.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssetGroupTableTable createAlias(String alias) {
    return $AssetGroupTableTable(_db, alias);
  }
}

class AssetItem extends DataClass implements Insertable<AssetItem> {
  final int id;
  final int kindId;
  final int groupId;
  final String name;
  final double quantity;
  final double price;
  final double targetPercent;
  AssetItem(
      {required this.id,
      required this.kindId,
      required this.groupId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.targetPercent});
  factory AssetItem.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return AssetItem(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      kindId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}kind_id'])!,
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}group_id'])!,
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      quantity: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
      price:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
      targetPercent: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}target_percent'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind_id'] = Variable<int>(kindId);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['target_percent'] = Variable<double>(targetPercent);
    return map;
  }

  AssetItemTableCompanion toCompanion(bool nullToAbsent) {
    return AssetItemTableCompanion(
      id: Value(id),
      kindId: Value(kindId),
      groupId: Value(groupId),
      name: Value(name),
      quantity: Value(quantity),
      price: Value(price),
      targetPercent: Value(targetPercent),
    );
  }

  factory AssetItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AssetItem(
      id: serializer.fromJson<int>(json['id']),
      kindId: serializer.fromJson<int>(json['kindId']),
      groupId: serializer.fromJson<int>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      targetPercent: serializer.fromJson<double>(json['targetPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kindId': serializer.toJson<int>(kindId),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'targetPercent': serializer.toJson<double>(targetPercent),
    };
  }

  AssetItem copyWith(
          {int? id,
          int? kindId,
          int? groupId,
          String? name,
          double? quantity,
          double? price,
          double? targetPercent}) =>
      AssetItem(
        id: id ?? this.id,
        kindId: kindId ?? this.kindId,
        groupId: groupId ?? this.groupId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        targetPercent: targetPercent ?? this.targetPercent,
      );
  @override
  String toString() {
    return (StringBuffer('AssetItem(')
          ..write('id: $id, ')
          ..write('kindId: $kindId, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          kindId.hashCode,
          $mrjc(
              groupId.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(quantity.hashCode,
                      $mrjc(price.hashCode, targetPercent.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AssetItem &&
          other.id == this.id &&
          other.kindId == this.kindId &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.targetPercent == this.targetPercent);
}

class AssetItemTableCompanion extends UpdateCompanion<AssetItem> {
  final Value<int> id;
  final Value<int> kindId;
  final Value<int> groupId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> targetPercent;
  const AssetItemTableCompanion({
    this.id = const Value.absent(),
    this.kindId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.targetPercent = const Value.absent(),
  });
  AssetItemTableCompanion.insert({
    this.id = const Value.absent(),
    required int kindId,
    required int groupId,
    required String name,
    required double quantity,
    required double price,
    required double targetPercent,
  })   : kindId = Value(kindId),
        groupId = Value(groupId),
        name = Value(name),
        quantity = Value(quantity),
        price = Value(price),
        targetPercent = Value(targetPercent);
  static Insertable<AssetItem> custom({
    Expression<int>? id,
    Expression<int>? kindId,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? targetPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kindId != null) 'kind_id': kindId,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (targetPercent != null) 'target_percent': targetPercent,
    });
  }

  AssetItemTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? kindId,
      Value<int>? groupId,
      Value<String>? name,
      Value<double>? quantity,
      Value<double>? price,
      Value<double>? targetPercent}) {
    return AssetItemTableCompanion(
      id: id ?? this.id,
      kindId: kindId ?? this.kindId,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      targetPercent: targetPercent ?? this.targetPercent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kindId.present) {
      map['kind_id'] = Variable<int>(kindId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (targetPercent.present) {
      map['target_percent'] = Variable<double>(targetPercent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetItemTableCompanion(')
          ..write('id: $id, ')
          ..write('kindId: $kindId, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }
}

class $AssetItemTableTable extends AssetItemTable
    with TableInfo<$AssetItemTableTable, AssetItem> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AssetItemTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _kindIdMeta = const VerificationMeta('kindId');
  @override
  late final GeneratedIntColumn kindId = _constructKindId();
  GeneratedIntColumn _constructKindId() {
    return GeneratedIntColumn(
      'kind_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  @override
  late final GeneratedIntColumn groupId = _constructGroupId();
  GeneratedIntColumn _constructGroupId() {
    return GeneratedIntColumn(
      'group_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  @override
  late final GeneratedRealColumn quantity = _constructQuantity();
  GeneratedRealColumn _constructQuantity() {
    return GeneratedRealColumn(
      'quantity',
      $tableName,
      false,
    );
  }

  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedRealColumn price = _constructPrice();
  GeneratedRealColumn _constructPrice() {
    return GeneratedRealColumn(
      'price',
      $tableName,
      false,
    );
  }

  final VerificationMeta _targetPercentMeta =
      const VerificationMeta('targetPercent');
  @override
  late final GeneratedRealColumn targetPercent = _constructTargetPercent();
  GeneratedRealColumn _constructTargetPercent() {
    return GeneratedRealColumn(
      'target_percent',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, kindId, groupId, name, quantity, price, targetPercent];
  @override
  $AssetItemTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'asset_item_table';
  @override
  final String actualTableName = 'asset_item_table';
  @override
  VerificationContext validateIntegrity(Insertable<AssetItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind_id')) {
      context.handle(_kindIdMeta,
          kindId.isAcceptableOrUnknown(data['kind_id']!, _kindIdMeta));
    } else if (isInserting) {
      context.missing(_kindIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('target_percent')) {
      context.handle(
          _targetPercentMeta,
          targetPercent.isAcceptableOrUnknown(
              data['target_percent']!, _targetPercentMeta));
    } else if (isInserting) {
      context.missing(_targetPercentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AssetItem.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssetItemTableTable createAlias(String alias) {
    return $AssetItemTableTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AssetKindTableTable assetKindTable = $AssetKindTableTable(this);
  late final $AssetGroupTableTable assetGroupTable =
      $AssetGroupTableTable(this);
  late final $AssetItemTableTable assetItemTable = $AssetItemTableTable(this);
  Future<int> _resetCategory(String var1) {
    return customUpdate(
      'UPDATE todos SET category = NULL WHERE category = ?',
      variables: [Variable<String>(var1)],
      updates: {},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<AssetGroup> getGroup() {
    return customSelect('SELECT * FROM asset_group_table',
        variables: [],
        readsFrom: {assetGroupTable}).map(assetGroupTable.mapFromRow);
  }

  Selectable<AssetItem> getData() {
    return customSelect('SELECT * FROM asset_item_table',
        variables: [],
        readsFrom: {assetItemTable}).map(assetItemTable.mapFromRow);
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [assetKindTable, assetGroupTable, assetItemTable];
}
