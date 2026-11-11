import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as paths;

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
      return NativeDatabase(dbFile, logStatements: logStatements);
    });
    return Database(executor);
  }
  return Database(NativeDatabase.memory(logStatements: logStatements));
}
