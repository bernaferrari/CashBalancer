// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  const User({required this.id, required this.name});
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  User copyWith({int? id, String? name}) => User(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
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

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorNameMeta =
      const VerificationMeta('colorName');
  @override
  late final GeneratedColumn<String> colorName = GeneratedColumn<String>(
      'color_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetPercentMeta =
      const VerificationMeta('targetPercent');
  @override
  late final GeneratedColumn<double> targetPercent = GeneratedColumn<double>(
      'target_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, name, colorName, targetPercent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(Insertable<Wallet> instance,
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
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_name'])!,
      targetPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_percent'])!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int id;
  final int userId;
  final String name;
  final String colorName;
  final double targetPercent;
  const Wallet(
      {required this.id,
      required this.userId,
      required this.name,
      required this.colorName,
      required this.targetPercent});
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

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      colorName: Value(colorName),
      targetPercent: Value(targetPercent),
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      colorName: serializer.fromJson<String>(json['colorName']),
      targetPercent: serializer.fromJson<double>(json['targetPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'colorName': serializer.toJson<String>(colorName),
      'targetPercent': serializer.toJson<double>(targetPercent),
    };
  }

  Wallet copyWith(
          {int? id,
          int? userId,
          String? name,
          String? colorName,
          double? targetPercent}) =>
      Wallet(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        colorName: colorName ?? this.colorName,
        targetPercent: targetPercent ?? this.targetPercent,
      );
  Wallet copyWithCompanion(WalletsCompanion data) {
    return Wallet(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      colorName: data.colorName.present ? data.colorName.value : this.colorName,
      targetPercent: data.targetPercent.present
          ? data.targetPercent.value
          : this.targetPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Wallet(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('colorName: $colorName, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name, colorName, targetPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.colorName == this.colorName &&
          other.targetPercent == this.targetPercent);
}

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<String> colorName;
  final Value<double> targetPercent;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.colorName = const Value.absent(),
    this.targetPercent = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    required String colorName,
    required double targetPercent,
  })  : userId = Value(userId),
        name = Value(name),
        colorName = Value(colorName),
        targetPercent = Value(targetPercent);
  static Insertable<Wallet> custom({
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

  WalletsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? name,
      Value<String>? colorName,
      Value<double>? targetPercent}) {
    return WalletsCompanion(
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
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('colorName: $colorName, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _walletIdMeta =
      const VerificationMeta('walletId');
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
      'wallet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetPercentMeta =
      const VerificationMeta('targetPercent');
  @override
  late final GeneratedColumn<double> targetPercent = GeneratedColumn<double>(
      'target_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, walletId, userId, name, quantity, price, targetPercent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(_walletIdMeta,
          walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta));
    } else if (isInserting) {
      context.missing(_walletIdMeta);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      walletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      targetPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_percent'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final int walletId;
  final int userId;
  final String name;
  final double quantity;
  final double price;
  final double targetPercent;
  const Item(
      {required this.id,
      required this.walletId,
      required this.userId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.targetPercent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
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
      walletId: Value(walletId),
      userId: Value(userId),
      name: Value(name),
      quantity: Value(quantity),
      price: Value(price),
      targetPercent: Value(targetPercent),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      targetPercent: serializer.fromJson<double>(json['targetPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'targetPercent': serializer.toJson<double>(targetPercent),
    };
  }

  Item copyWith(
          {int? id,
          int? walletId,
          int? userId,
          String? name,
          double? quantity,
          double? price,
          double? targetPercent}) =>
      Item(
        id: id ?? this.id,
        walletId: walletId ?? this.walletId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        targetPercent: targetPercent ?? this.targetPercent,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      targetPercent: data.targetPercent.present
          ? data.targetPercent.value
          : this.targetPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, walletId, userId, name, quantity, price, targetPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.targetPercent == this.targetPercent);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<int> userId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> targetPercent;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.targetPercent = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required int userId,
    required String name,
    required double quantity,
    required double price,
    required double targetPercent,
  })  : walletId = Value(walletId),
        userId = Value(userId),
        name = Value(name),
        quantity = Value(quantity),
        price = Value(price),
        targetPercent = Value(targetPercent);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? targetPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (targetPercent != null) 'target_percent': targetPercent,
    });
  }

  ItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? walletId,
      Value<int>? userId,
      Value<String>? name,
      Value<double>? quantity,
      Value<double>? price,
      Value<double>? targetPercent}) {
    return ItemsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
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
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
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
          ..write('walletId: $walletId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('targetPercent: $targetPercent')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  Selectable<int> userExists() {
    return customSelect(
        'SELECT count(1) AS _c0 WHERE EXISTS (SELECT * FROM users)',
        variables: [],
        readsFrom: {
          users,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, wallets, items];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$UsersTableFilterComposer extends Composer<_$Database, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer extends Composer<_$Database, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer extends Composer<_$Database, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$Database,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$Database, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$Database db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$Database, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  required int userId,
  required String name,
  required String colorName,
  required double targetPercent,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> name,
  Value<String> colorName,
  Value<double> targetPercent,
});

class $$WalletsTableFilterComposer extends Composer<_$Database, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorName => $composableBuilder(
      column: $table.colorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetPercent => $composableBuilder(
      column: $table.targetPercent, builder: (column) => ColumnFilters(column));
}

class $$WalletsTableOrderingComposer
    extends Composer<_$Database, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorName => $composableBuilder(
      column: $table.colorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetPercent => $composableBuilder(
      column: $table.targetPercent,
      builder: (column) => ColumnOrderings(column));
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$Database, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorName =>
      $composableBuilder(column: $table.colorName, builder: (column) => column);

  GeneratedColumn<double> get targetPercent => $composableBuilder(
      column: $table.targetPercent, builder: (column) => column);
}

class $$WalletsTableTableManager extends RootTableManager<
    _$Database,
    $WalletsTable,
    Wallet,
    $$WalletsTableFilterComposer,
    $$WalletsTableOrderingComposer,
    $$WalletsTableAnnotationComposer,
    $$WalletsTableCreateCompanionBuilder,
    $$WalletsTableUpdateCompanionBuilder,
    (Wallet, BaseReferences<_$Database, $WalletsTable, Wallet>),
    Wallet,
    PrefetchHooks Function()> {
  $$WalletsTableTableManager(_$Database db, $WalletsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> colorName = const Value.absent(),
            Value<double> targetPercent = const Value.absent(),
          }) =>
              WalletsCompanion(
            id: id,
            userId: userId,
            name: name,
            colorName: colorName,
            targetPercent: targetPercent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String name,
            required String colorName,
            required double targetPercent,
          }) =>
              WalletsCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            colorName: colorName,
            targetPercent: targetPercent,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WalletsTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $WalletsTable,
    Wallet,
    $$WalletsTableFilterComposer,
    $$WalletsTableOrderingComposer,
    $$WalletsTableAnnotationComposer,
    $$WalletsTableCreateCompanionBuilder,
    $$WalletsTableUpdateCompanionBuilder,
    (Wallet, BaseReferences<_$Database, $WalletsTable, Wallet>),
    Wallet,
    PrefetchHooks Function()>;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required int walletId,
  required int userId,
  required String name,
  required double quantity,
  required double price,
  required double targetPercent,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<int> walletId,
  Value<int> userId,
  Value<String> name,
  Value<double> quantity,
  Value<double> price,
  Value<double> targetPercent,
});

class $$ItemsTableFilterComposer extends Composer<_$Database, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetPercent => $composableBuilder(
      column: $table.targetPercent, builder: (column) => ColumnFilters(column));
}

class $$ItemsTableOrderingComposer extends Composer<_$Database, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetPercent => $composableBuilder(
      column: $table.targetPercent,
      builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableAnnotationComposer extends Composer<_$Database, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get targetPercent => $composableBuilder(
      column: $table.targetPercent, builder: (column) => column);
}

class $$ItemsTableTableManager extends RootTableManager<
    _$Database,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, BaseReferences<_$Database, $ItemsTable, Item>),
    Item,
    PrefetchHooks Function()> {
  $$ItemsTableTableManager(_$Database db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> walletId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> targetPercent = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            walletId: walletId,
            userId: userId,
            name: name,
            quantity: quantity,
            price: price,
            targetPercent: targetPercent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int walletId,
            required int userId,
            required String name,
            required double quantity,
            required double price,
            required double targetPercent,
          }) =>
              ItemsCompanion.insert(
            id: id,
            walletId: walletId,
            userId: userId,
            name: name,
            quantity: quantity,
            price: price,
            targetPercent: targetPercent,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, BaseReferences<_$Database, $ItemsTable, Item>),
    Item,
    PrefetchHooks Function()>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
}
