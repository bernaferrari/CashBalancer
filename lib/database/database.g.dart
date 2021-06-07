// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  User({required this.id, required this.name});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
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

  User copyWith({int? id, String? name}) => User(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User && other.id == this.id && other.name == this.name);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  UsersCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return UsersCompanion(
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
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
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
  $UsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'users';
  @override
  final String actualTableName = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
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
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final int userId;
  final String name;
  final String colorName;
  final double targetPercent;

  Group(
      {required this.id,
      required this.userId,
      required this.name,
      required this.colorName,
      required this.targetPercent});

  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Group(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      userId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      colorName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color_name'])!,
      targetPercent: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}target_percent'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['color_name'] = Variable<String>(colorName);
    map['target_percent'] = Variable<double>(targetPercent);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      colorName: Value(colorName),
      targetPercent: Value(targetPercent),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      colorName: serializer.fromJson<String>(json['colorName']),
      targetPercent: serializer.fromJson<double>(json['targetPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'colorName': serializer.toJson<String>(colorName),
      'targetPercent': serializer.toJson<double>(targetPercent),
    };
  }

  Group copyWith(
          {int? id,
          int? userId,
          String? name,
          String? colorName,
          double? targetPercent}) =>
      Group(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        colorName: colorName ?? this.colorName,
        targetPercent: targetPercent ?? this.targetPercent,
      );

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('colorName: $colorName, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(name.hashCode,
              $mrjc(colorName.hashCode, targetPercent.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.colorName == this.colorName &&
          other.targetPercent == this.targetPercent);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<String> colorName;
  final Value<double> targetPercent;

  const GroupsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.colorName = const Value.absent(),
    this.targetPercent = const Value.absent(),
  });

  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    required String colorName,
    required double targetPercent,
  })  : userId = Value(userId),
        name = Value(name),
        colorName = Value(colorName),
        targetPercent = Value(targetPercent);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<String>? colorName,
    Expression<double>? targetPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (colorName != null) 'color_name': colorName,
      if (targetPercent != null) 'target_percent': targetPercent,
    });
  }

  GroupsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? name,
      Value<String>? colorName,
      Value<double>? targetPercent}) {
    return GroupsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      colorName: colorName ?? this.colorName,
      targetPercent: targetPercent ?? this.targetPercent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorName.present) {
      map['color_name'] = Variable<String>(colorName.value);
    }
    if (targetPercent.present) {
      map['target_percent'] = Variable<double>(targetPercent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('colorName: $colorName, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  final GeneratedDatabase _db;
  final String? _alias;

  $GroupsTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedIntColumn userId = _constructUserId();

  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
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

  final VerificationMeta _colorNameMeta = const VerificationMeta('colorName');
  @override
  late final GeneratedTextColumn colorName = _constructColorName();

  GeneratedTextColumn _constructColorName() {
    return GeneratedTextColumn(
      'color_name',
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
      [id, userId, name, colorName, targetPercent];

  @override
  $GroupsTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? '"groups"';
  @override
  final String actualTableName = '"groups"';

  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_name')) {
      context.handle(_colorNameMeta,
          colorName.isAcceptableOrUnknown(data['color_name']!, _colorNameMeta));
    } else if (isInserting) {
      context.missing(_colorNameMeta);
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
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Group.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(_db, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final int groupId;
  final int userId;
  final String name;
  final double quantity;
  final double price;
  final double targetPercent;
  Item(
      {required this.id,
      required this.groupId,
      required this.userId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.targetPercent});
  factory Item.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Item(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      groupId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}group_id'])!,
      userId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      quantity: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
      price: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
      targetPercent: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}target_percent'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['target_percent'] = Variable<double>(targetPercent);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      userId: Value(userId),
      name: Value(name),
      quantity: Value(quantity),
      price: Value(price),
      targetPercent: Value(targetPercent),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      userId: serializer.fromJson<int>(json['userId']),
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
      'groupId': serializer.toJson<int>(groupId),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'targetPercent': serializer.toJson<double>(targetPercent),
    };
  }

  Item copyWith(
          {int? id,
          int? groupId,
          int? userId,
          String? name,
          double? quantity,
          double? price,
          double? targetPercent}) =>
      Item(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        targetPercent: targetPercent ?? this.targetPercent,
      );
  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
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
          groupId.hashCode,
          $mrjc(
              userId.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(quantity.hashCode,
                      $mrjc(price.hashCode, targetPercent.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.targetPercent == this.targetPercent);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> userId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> targetPercent;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.targetPercent = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int userId,
    required String name,
    required double quantity,
    required double price,
    required double targetPercent,
  })  : groupId = Value(groupId),
        userId = Value(userId),
        name = Value(name),
        quantity = Value(quantity),
        price = Value(price),
        targetPercent = Value(targetPercent);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? targetPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (targetPercent != null) 'target_percent': targetPercent,
    });
  }

  ItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? userId,
      Value<String>? name,
      Value<double>? quantity,
      Value<double>? price,
      Value<double>? targetPercent}) {
    return ItemsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
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
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
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
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ItemsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
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

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedIntColumn userId = _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
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
      [id, groupId, userId, name, quantity, price, targetPercent];
  @override
  $ItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'items';
  @override
  final String actualTableName = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
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
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Item.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  Selectable<int> userExists() {
    return customSelect('SELECT count(1) where exists (select * from users)',
        variables: [],
        readsFrom: {users}).map((QueryRow row) => row.read<int>('count(1)'));
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, groups, items];
}
