import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  return Database(
    LazyDatabase(() async {
      final result = await WasmDatabase.open(
        databaseName: 'db',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    }),
  );
}