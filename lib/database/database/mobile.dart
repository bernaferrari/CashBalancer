import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as paths;
import 'package:sqlite3/sqlite3.dart' show OpenMode, sqlite3;

import '../database.dart';

Database constructDb({bool logStatements = false}) {
  if (Platform.isIOS ||
      Platform.isAndroid ||
      Platform.isMacOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
      if ((Platform.isMacOS || Platform.isLinux) && !await dbFile.exists()) {
        final legacyPath = p.absolute('db.sqlite');
        if (p.normalize(legacyPath) != p.normalize(dbFile.path) &&
            await File(legacyPath).exists()) {
          await copyLegacyDatabase(File(legacyPath), dbFile);
        }
      }
      return NativeDatabase(dbFile, logStatements: logStatements);
    });
    return Database(executor);
  }
  return Database(NativeDatabase.memory(logStatements: logStatements));
}

/// Recover a 1.0 database without writing to the original file.
Future<void> copyLegacyDatabase(File legacy, File destination) async {
  final source = sqlite3.open(legacy.path, mode: OpenMode.readOnly);
  try {
    final tables = source
        .select("SELECT name FROM sqlite_master WHERE type = 'table'")
        .map((row) => row['name'])
        .toSet();
    // The repository also ships an empty, pre-1.0 db.sqlite template.
    if (!tables.containsAll(['users', 'wallets', 'items'])) return;
    final staging = await destination.parent.createTemp(
      '.cash-balancer-migration-',
    );
    try {
      final snapshot = p.join(staging.path, 'db.sqlite');
      source.execute('VACUUM INTO ?', [snapshot]);
      if (!await destination.exists()) {
        await File(snapshot).rename(destination.path);
      }
    } finally {
      await staging.delete(recursive: true);
    }
  } finally {
    source.close();
  }
}
