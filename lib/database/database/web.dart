import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
// The legacy reader is only used to seed a new Wasm database.
// ignore: deprecated_member_use
import 'package:drift/web.dart' show DriftWebStorage;

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  return Database(
    LazyDatabase(() async {
      final result = await WasmDatabase.open(
        databaseName: 'db',
        initializeDatabase: () async {
          // Moor 1.0 used localStorage and saved user_version separately.
          const legacy = DriftWebStorage('db');
          await legacy.open();
          try {
            final bytes = await legacy.restore();
            if (bytes != null && bytes.length >= 100) {
              final header = ByteData.sublistView(bytes);
              if (header.getUint32(60) == 0) header.setUint32(60, 1);
            }
            return bytes;
          } finally {
            await legacy.close();
          }
        },
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    }),
  );
}
