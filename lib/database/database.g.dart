// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Kind extends DataClass implements Insertable<Kind> {
  final int id;
  final String name;
  final String color;
  Kind({required this.id, required this.name, required this.color});
  factory Kind.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Kind(
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

  AssetKindCompanion toCompanion(bool nullToAbsent) {
    return AssetKindCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  factory Kind.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Kind(
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

  Kind copyWith({int? id, String? name, String? color}) => Kind(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('Kind(')
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
      (other is Kind &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class AssetKindCompanion extends UpdateCompanion<Kind> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  const AssetKindCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  AssetKindCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String color,
  })   : name = Value(name),
        color = Value(color);
  static Insertable<Kind> custom({
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

  AssetKindCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? color}) {
    return AssetKindCompanion(
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
    return (StringBuffer('AssetKindCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $AssetKindTable extends AssetKind with TableInfo<$AssetKindTable, Kind> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AssetKindTable(this._db, [this._alias]);
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
  $AssetKindTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'asset_kind';
  @override
  final String actualTableName = 'asset_kind';
  @override
  VerificationContext validateIntegrity(Insertable<Kind> instance,
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
  Kind map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Kind.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssetKindTable createAlias(String alias) {
    return $AssetKindTable(_db, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String name;
  Group({required this.id, required this.name});
  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Group(
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

  AssetGroupCompanion toCompanion(bool nullToAbsent) {
    return AssetGroupCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Group(
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

  Group copyWith({int? id, String? name}) => Group(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
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
      (other is Group && other.id == this.id && other.name == this.name);
}

class AssetGroupCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  const AssetGroupCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  AssetGroupCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  AssetGroupCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return AssetGroupCompanion(
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
    return (StringBuffer('AssetGroupCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $AssetGroupTable extends AssetGroup
    with TableInfo<$AssetGroupTable, Group> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AssetGroupTable(this._db, [this._alias]);
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
  $AssetGroupTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'asset_group';
  @override
  final String actualTableName = 'asset_group';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
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
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Group.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssetGroupTable createAlias(String alias) {
    return $AssetGroupTable(_db, alias);
  }
}

class Data extends DataClass implements Insertable<Data> {
  final int id;
  final int typeId;
  final int groupId;
  final String name;
  final double quantity;
  final double price;
  final double targetPercent;
  Data(
      {required this.id,
      required this.typeId,
      required this.groupId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.targetPercent});
  factory Data.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Data(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      typeId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}type_id'])!,
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
    map['type_id'] = Variable<int>(typeId);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['target_percent'] = Variable<double>(targetPercent);
    return map;
  }

  AssetDataCompanion toCompanion(bool nullToAbsent) {
    return AssetDataCompanion(
      id: Value(id),
      typeId: Value(typeId),
      groupId: Value(groupId),
      name: Value(name),
      quantity: Value(quantity),
      price: Value(price),
      targetPercent: Value(targetPercent),
    );
  }

  factory Data.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Data(
      id: serializer.fromJson<int>(json['id']),
      typeId: serializer.fromJson<int>(json['typeId']),
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
      'typeId': serializer.toJson<int>(typeId),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'targetPercent': serializer.toJson<double>(targetPercent),
    };
  }

  Data copyWith(
          {int? id,
          int? typeId,
          int? groupId,
          String? name,
          double? quantity,
          double? price,
          double? targetPercent}) =>
      Data(
        id: id ?? this.id,
        typeId: typeId ?? this.typeId,
        groupId: groupId ?? this.groupId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        targetPercent: targetPercent ?? this.targetPercent,
      );
  @override
  String toString() {
    return (StringBuffer('Data(')
          ..write('id: $id, ')
          ..write('typeId: $typeId, ')
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
          typeId.hashCode,
          $mrjc(
              groupId.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(quantity.hashCode,
                      $mrjc(price.hashCode, targetPercent.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Data &&
          other.id == this.id &&
          other.typeId == this.typeId &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.targetPercent == this.targetPercent);
}

class AssetDataCompanion extends UpdateCompanion<Data> {
  final Value<int> id;
  final Value<int> typeId;
  final Value<int> groupId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> targetPercent;
  const AssetDataCompanion({
    this.id = const Value.absent(),
    this.typeId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.targetPercent = const Value.absent(),
  });
  AssetDataCompanion.insert({
    this.id = const Value.absent(),
    required int typeId,
    required int groupId,
    required String name,
    required double quantity,
    required double price,
    required double targetPercent,
  })   : typeId = Value(typeId),
        groupId = Value(groupId),
        name = Value(name),
        quantity = Value(quantity),
        price = Value(price),
        targetPercent = Value(targetPercent);
  static Insertable<Data> custom({
    Expression<int>? id,
    Expression<int>? typeId,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? targetPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typeId != null) 'type_id': typeId,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (targetPercent != null) 'target_percent': targetPercent,
    });
  }

  AssetDataCompanion copyWith(
      {Value<int>? id,
      Value<int>? typeId,
      Value<int>? groupId,
      Value<String>? name,
      Value<double>? quantity,
      Value<double>? price,
      Value<double>? targetPercent}) {
    return AssetDataCompanion(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
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
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
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
    return (StringBuffer('AssetDataCompanion(')
          ..write('id: $id, ')
          ..write('typeId: $typeId, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }
}

class $AssetDataTable extends AssetData with TableInfo<$AssetDataTable, Data> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AssetDataTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedIntColumn typeId = _constructTypeId();
  GeneratedIntColumn _constructTypeId() {
    return GeneratedIntColumn(
      'type_id',
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
      [id, typeId, groupId, name, quantity, price, targetPercent];
  @override
  $AssetDataTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'asset_data';
  @override
  final String actualTableName = 'asset_data';
  @override
  VerificationContext validateIntegrity(Insertable<Data> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
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
  Data map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Data.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssetDataTable createAlias(String alias) {
    return $AssetDataTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AssetKindTable assetKind = $AssetKindTable(this);
  late final $AssetGroupTable assetGroup = $AssetGroupTable(this);
  late final $AssetDataTable assetData = $AssetDataTable(this);
  Future<int> _resetCategory(String var1) {
    return customUpdate(
      'UPDATE todos SET category = NULL WHERE category = ?',
      variables: [Variable<String>(var1)],
      updates: {},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<Group> getGroup() {
    return customSelect('SELECT * FROM asset_group',
        variables: [], readsFrom: {assetGroup}).map(assetGroup.mapFromRow);
  }

  Selectable<Data> getData() {
    return customSelect('SELECT * FROM asset_data',
        variables: [], readsFrom: {assetData}).map(assetData.mapFromRow);
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [assetKind, assetGroup, assetData];
}
