import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

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
    final rxPrefs = RxSharedPreferences.getInstance();
    int? userId = targetUserId ?? await rxPrefs.getInt('activeUserId');
    final existingUsers = await db.select(db.users).get();
    if (userId == null || !existingUsers.any((u) => u.id == userId)) {
      userId = await db.getDefaultUser();
    }
    if (targetUserId != null) {
      await rxPrefs.setInt('activeUserId', userId);
    }
    if (isClosed) return;
    await _currentEntries?.cancel();
    _currentEntries = db.watchWallets(userId).listen(emit);
  }

  Future<void> switchPortfolio(int userId) => initData(userId);
}
