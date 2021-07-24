import 'dart:async';

import 'package:bloc/bloc.dart';

import '../database/data.dart';
import '../database/database.dart';

class DataCubit extends Cubit<FullData?> {
  final Database db;

  late final StreamSubscription<FullData> _currentEntries;

  DataCubit(this.db) : super(null) {
    initData();
  }

  @override
  Future<void> close() {
    _currentEntries.cancel();
    return super.close();
  }

  Future<void> initData() async {
    final int userId = await db.getDefaultUser();
    _currentEntries = db.watchWallets(userId).listen(emit);
  }
}
