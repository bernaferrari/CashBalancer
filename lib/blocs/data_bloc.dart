import 'dart:async';

import 'package:bloc/bloc.dart';

import '../database/data.dart';
import '../database/database.dart';

class DataCubit(final Database db) extends Cubit<FullData?> {
  StreamSubscription<FullData>? _currentEntries;

  this : super(null) {
    initData();
  }

  @override
  Future<void> close() {
    _currentEntries?.cancel();
    return super.close();
  }

  Future<void> initData() async {
    final int userId = await db.getDefaultUser();
    if (isClosed) return;
    _currentEntries = db.watchWallets(userId).listen(emit);
  }
}
