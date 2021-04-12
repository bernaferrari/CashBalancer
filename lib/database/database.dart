// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'dart:ui';

import 'package:cash_balancer/util/get_color_by_quantile.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';

export 'database/shared.dart';

part 'database.g.dart';

@DataClassName('AssetKind')
class AssetKindTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get color => text()();
}

@DataClassName('AssetGroup')
class AssetGroupTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

@DataClassName('AssetItem')
class AssetItemTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get kindId => integer()();

  IntColumn get groupId => integer()();

  TextColumn get name => text()();

  RealColumn get quantity => real()();

  RealColumn get price => real()();

  RealColumn get targetPercent => real()();
}

class FullData extends FullDataNullable {
  const FullData(
    AssetGroup group,
    this.item,
    this.kind,
  ) : super(group);

  final AssetItem item;
  final AssetKind kind;
}

class ItemKindData {
  const ItemKindData(
    this.item,
    this.kind,
  );

  final AssetItem item;
  final AssetKind kind;
}

class FullDataNullable {
  const FullDataNullable(this.group);

  final AssetGroup group;
}

class FullDataExtended {
  const FullDataExtended(this.groupedData, this.colors, this.fullData);

  final Map<int, List<FullData>> groupedData;
  final List<FullData> fullData;
  final Map<FullData, Color> colors;
}

@UseMoor(
  tables: [AssetKindTable, AssetGroupTable, AssetItemTable],
  queries: {
    '_resetCategory': 'UPDATE todos SET category = NULL WHERE category = ?',
    'getGroup': 'SELECT * FROM asset_group_table',
    'getKind': 'SELECT * FROM asset_kind_table,',
    'getData': 'SELECT * FROM asset_item_table',
  },
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) {
        return m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // if (from == 1) {
        //   await m.addColumn(todos, todos.targetDate);
        // }
      },
      beforeOpen: (details) async {
        // if (details.wasCreated) {
        //   // create default categories and entries
        //   final workId = await into(categories)
        //       .insert(const CategoriesCompanion(description: Value('Work')));
        //
        //   await into(todos).insert(TodosCompanion(
        //     content: const Value('A first todo entry'),
        //     targetDate: Value(DateTime.now()),
        //   ));
        //
        //   await into(todos).insert(
        //     TodosCompanion(
        //       content: const Value('Rework persistence code'),
        //       category: Value(workId),
        //       targetDate: Value(
        //         DateTime.now().add(const Duration(days: 4)),
        //       ),
        //     ),
        //   );
        // }
      },
    );
  }

// Stream<List<CategoryWithCount>> categoriesWithCount() {
//   // the _categoriesWithCount method has been generated automatically based
//   // on the query declared in the @UseMoor annotation
//   return _categoriesWithCount().map((row) {
//     final category = Category(id: row.id, description: row.desc);
//
//     return CategoryWithCount(category, row.amount);
//   }).watch();
// }
//
// /// Watches all entries in the given [category]. If the category is null, all
// /// entries will be shown instead.

  Stream<Map<AssetGroup, List<ItemKindData>>> watchGroups() {
    final groupQuery = select(assetGroupTable);

    // These can be empty.
    final itemsQuery = select(assetItemTable)
        .join([
          leftOuterJoin(
            assetKindTable,
            assetKindTable.id.equalsExp(assetItemTable.kindId),
          ),
        ])
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => ItemKindData(
                  row.readTable(assetItemTable),
                  row.readTable(assetKindTable),
                ),
              )
              .toList(),
        );

    return Rx.combineLatest2(groupQuery.watch(), itemsQuery,
        // ignore: avoid_types_on_closure_parameters
        (List<AssetGroup> a, List<ItemKindData> b) {
      final map = <AssetGroup, List<ItemKindData>>{};

      for (final group in a) {
        map[group] =
            b.where((element) => element.item.groupId == group.id).toList();
      }

      return map;
    });
  }

  Stream<List<FullData>> watchItems() {
    final query2 = select(assetItemTable).join([
      leftOuterJoin(
        assetGroupTable,
        assetGroupTable.id.equalsExp(assetItemTable.groupId),
      ),
      leftOuterJoin(
        assetKindTable,
        assetKindTable.id.equalsExp(assetItemTable.kindId),
      ),
    ]);

    query2.get().then((value) {
      print("query2: ${value}");
    });

    final query3 = select(assetGroupTable);

    query3.get().then((value) {
      print("query3: ${value}");
    });

    final query = select(assetItemTable).join([
      leftOuterJoin(
        assetGroupTable,
        assetGroupTable.id.equalsExp(assetItemTable.groupId),
      ),
      leftOuterJoin(
        assetKindTable,
        assetKindTable.id.equalsExp(assetItemTable.kindId),
      ),
    ]);

    return query.watch().map((rows) {
      // read both the entry and the associated category for each row
      return rows.map((row) {
        return FullData(
          row.readTable(assetGroupTable),
          row.readTable(assetItemTable),
          row.readTable(assetKindTable),
        );
      }).toList();
    });
  }

  // Stream<FullDataExtended> watchItemsGroupedHome() {
  //   return watchGroups().map((data) {
  //     final List<FullDataNullable> sortedData = [...data]..sort((a, b) {
  //         return (b.item.price * b.item.quantity)
  //             .compareTo((a.item.price * a.item.quantity));
  //       });
  //
  //     final Map<int, List<FullData>> groupedData = groupByKind(sortedData);
  //
  //     final Map<FullData, Color> colors =
  //         getColorByQuantile(groupedData, sortedData);
  //
  //     return FullDataExtended(groupedData, colors, sortedData);
  //   });
  // }

  Stream<FullDataExtended> watchItemsGrouped() {
    return watchItems().map((data) {
      final List<FullData> sortedData = [...data]..sort((a, b) {
          return (b.item.price * b.item.quantity)
              .compareTo((a.item.price * a.item.quantity));
        });

      final Map<int, List<FullData>> groupedData = groupByKind(sortedData);

      final Map<FullData, Color> colors =
          getColorByQuantile(groupedData, sortedData);

      return FullDataExtended(groupedData, colors, sortedData);
    });
  }

  Map<int, List<FullData>> groupByKind(List<FullData> data) {
    final groupedList = <int, List<FullData>>{};

    for (int i = 0; i < data.length; i++) {
      final groupPosition = groupedList[data[i].item.kindId];
      if (groupPosition != null) {
        groupPosition.add(data[i]);
      } else {
        groupedList[data[i].item.kindId] = [data[i]];
      }
    }

    return groupedList;
  }

  Stream<List<FullData>> watchMainGroups() {
    final query = select(assetGroupTable).join([
      leftOuterJoin(
        assetItemTable,
        assetGroupTable.id.equalsExp(assetItemTable.groupId),
      ),
      leftOuterJoin(
        assetKindTable,
        assetKindTable.id.equalsExp(assetItemTable.kindId),
      ),
    ]);

    return query.watch().map((rows) {
      // read both the entry and the associated category for each row
      return rows.map((row) {
        return FullData(
          row.readTable(assetGroupTable),
          row.readTable(assetItemTable),
          row.readTable(assetKindTable),
        );
      }).toList();
    });
  }

//
// Future createEntry(TodosCompanion entry) {
//   return into(todos).insert(entry);
// }
//
// /// Updates the row in the database represents this entry by writing the
// /// updated data.
// Future updateEntry(TodoEntry entry) {
//   return update(todos).replace(entry);
// }
//
// Future deleteEntry(TodoEntry entry) {
//   return delete(todos).delete(entry);
// }
//
// Future<int> createCategory(String description) {
//   return into(categories)
//       .insert(CategoriesCompanion(description: Value(description)));
// }
  Future<int> createGroup(String description) {
    return into(assetGroupTable)
        .insert(AssetGroupTableCompanion.insert(name: description));
  }

  Future<bool> editGroup(AssetGroup group) {
    return update(assetGroupTable).replace(group);
  }

//
// Future deleteCategory(Category category) {
//   return transaction<dynamic>(() async {
//     await _resetCategory(category.id);
//     await delete(categories).delete(category);
//   });
// }
}
