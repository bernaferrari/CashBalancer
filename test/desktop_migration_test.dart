import 'dart:io';

import 'package:cash_balancer/database/database.dart';
import 'package:cash_balancer/database/database/mobile.dart'
    show copyLegacyDatabase;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' show sqlite3, OpenMode;

void main() {
  test('copies a legacy desktop database, including WAL rows, without modifying it', () async {
    final directory = await Directory.systemTemp.createTemp(
      'cash-balancer-test',
    );
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}/legacy.sqlite');
    final target = File('${directory.path}/documents.sqlite');
    final legacy = sqlite3.open(source.path);
    try {
      legacy.execute('''
        PRAGMA journal_mode = WAL;
        CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);
        CREATE TABLE wallets (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, name TEXT NOT NULL, color_name TEXT NOT NULL, target_percent REAL NOT NULL);
        CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT, wallet_id INTEGER NOT NULL, user_id INTEGER NOT NULL, name TEXT NOT NULL, quantity REAL NOT NULL, price REAL NOT NULL, target_percent REAL NOT NULL);
        INSERT INTO users VALUES (1, 'Desktop portfolio');
        INSERT INTO wallets VALUES (1, 1, 'Stocks', 'sky', 100);
        INSERT INTO items VALUES (1, 1, 1, 'AAPL', 8, 220, 100);
        PRAGMA user_version = 1;
      ''');
      await copyLegacyDatabase(source, target);
    } finally {
      legacy.close();
    }
    final upgraded = Database(NativeDatabase(target));
    try {
      expect(
        (await upgraded.select(upgraded.users).getSingle()).name,
        'Desktop portfolio',
      );
      expect((await upgraded.getItemFromId(1))!.quantity, 8);
    } finally {
      await upgraded.close();
    }
    final unchanged = sqlite3.open(source.path, mode: OpenMode.readOnly);
    try {
      expect(unchanged.select('PRAGMA user_version').single.values.single, 1);
    } finally {
      unchanged.close();
    }
  });
}
