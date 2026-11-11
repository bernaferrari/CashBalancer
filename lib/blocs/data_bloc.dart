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

  Future<void> initData([int? targetUserId]) async {
    final int userId = targetUserId ?? await db.getDefaultUser();
    if (isClosed) return;
    await _currentEntries?.cancel();
    _currentEntries = db.watchWallets(userId).listen(emit);
  }

  Future<void> switchPortfolio(int userId) => initData(userId);
}
