import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    _currentEntries = db.watchGroups(userId).listen(emit);
  }

  Future<Map<String, dynamic>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);

    return {};
  }
}
