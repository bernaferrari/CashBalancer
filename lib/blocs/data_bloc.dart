import 'dart:async';

import 'package:bloc/bloc.dart';

import '../database/data.dart';
import '../database/database.dart';

class DataCubit extends Cubit<FullData?> {
  final Database db;

  late final StreamSubscription<FullData> _currentEntries;

  DataCubit(this.db) : super(null) {
    db.getDefaultUser().then((userId) {
      _currentEntries = db.watchGroups(userId).listen(emit);
    });
  }

  @override
  Future<void> close() {
    _currentEntries.cancel();
    return super.close();
  }
}
