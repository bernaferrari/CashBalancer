// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'dart:ui';

import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../util/get_color_by_quantile.dart';

export 'database/shared.dart';

part 'database.g.dart';

class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get color => text()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId => integer()();

  IntColumn get userId => integer()();

  TextColumn get name => text()();

  RealColumn get quantity => real()();

  RealColumn get price => real()();

  RealColumn get targetPercent => real()();
}

// class FullData extends FullDataNullable {
//   const FullData(
//     User user,
//     this.item,
//     this.group,
//   ) : super(user);
//
//   final Item item;
//   final Group group;
// }

// class ItemKindData {
//   const ItemKindData(
//     this.item,
//     this.kind,
//   );
//
//   final Item item;
//   final Group kind;
// }

// class FullDataNullable {
//   const FullDataNullable(this.user);
//
//   final User user;
// }

// class FullDataExtended {
//   const FullDataExtended(this.groupedData, this.colors, this.fullData);
//
//   final Map<int, List<FullData>> groupedData;
//   final List<FullData> fullData;
//   final Map<FullData, Color> colors;
// }

class DataExtended {
  const DataExtended(
      this.itemsList, this.itemsMap, this.groupsMap, this.colorsMap);

  // List of Items
  final List<Item> itemsList;

  // groupID -> Items
  final Map<int, List<Item>> itemsMap;

  // groupID -> Groups
  final Map<int, Group> groupsMap;

  // Items -> Colors
  final Map<Item, Color> colorsMap;
}

@UseMoor(
  tables: [Users, Groups, Items],
  queries: {
    // '_resetCategory': 'UPDATE todos SET category = NULL WHERE category = ?',
    'userExists': """SELECT count(1) where exists (select * from users)"""
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

  // Users, Groups : [Items]
  Stream<DataExtended> watchGroups(int userId) {
    final groupsQuery = select(groups);

    final itemsQuery = select(items)
      ..where((item) => item.userId.equals(userId));

    return Rx.combineLatest2<List<Group>, List<Item>, DataExtended>(
        groupsQuery.watch(), itemsQuery.watch(), (groupList, itemsList) {
      final groupMap = <int, Group>{};
      for (final group in groupList) {
        groupMap[group.id] = group;
      }

      final List<Item> sortedItems = [...itemsList]..sort((a, b) {
          return (b.price * b.quantity).compareTo((a.price * a.quantity));
        });

      final Map<int, List<Item>> groupedItems = groupByKind(sortedItems);

      final Map<Item, Color> colors =
          getColorByQuantile(groupedItems, groupMap, sortedItems);

      return DataExtended(sortedItems, groupedItems, groupMap, colors);
    });
  }

  // Stream<List<FullData>> watchItems(int userId) {
  //   final queryUser = select(users)..where((user) => user.id.equals(userId));
  //
  //   final query = queryUser.join([
  //     leftOuterJoin(
  //       items,
  //       items.userId.equalsExp(users.id),
  //     ),
  //     // leftOuterJoin(
  //     //   groups,
  //     //   groups.id.equalsExp(items.groupId),
  //     // ),
  //   ]);
  //
  //   return query.watch().map((rows) {
  //     print("rows are $rows");
  //     // read both the entry and the associated category for each row
  //     return rows.map((row) {
  //       return FullData(
  //         row.readTable(users),
  //         row.readTable(items),
  //         row.readTable(groups),
  //       );
  //     }).toList();
  //   });
  // }

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

  // Stream<FullDataExtended> watchItemsGrouped(int userId) =>
  //     watchItems(userId).map((data) {
  //       print("watchItemsGrouped was updated, now $data");
  //
  //       final List<FullData> sortedData = [...data]..sort((a, b) {
  //           return (b.item.price * b.item.quantity)
  //               .compareTo((a.item.price * a.item.quantity));
  //         });
  //
  //       final Map<int, List<FullData>> groupedData = groupByKind(sortedData);
  //       print("sortedData: $sortedData groupedData $groupedData");
  //
  //       final Map<FullData, Color> colors =
  //           getColorByQuantile(groupedData, sortedData);
  //       print("colors: $colors");
  //
  //       return FullDataExtended(groupedData, colors, sortedData);
  //     });

  Map<int, List<Item>> groupByKind(List<Item> itemList) {
    final groupedList = <int, List<Item>>{};

    for (int i = 0; i < itemList.length; i++) {
      final groupId = itemList[i].groupId;

      final groupPosition = groupedList[groupId];
      if (groupPosition != null) {
        groupPosition.add(itemList[i]);
      } else {
        groupedList[groupId] = [itemList[i]];
      }
    }

    return groupedList;
  }

  // Stream<List<FullData>> watchMainGroups() {
  //   final query = select(users).join([
  //     leftOuterJoin(
  //       items,
  //       users.id.equalsExp(items.userId),
  //     ),
  //     leftOuterJoin(
  //       groups,
  //       groups.id.equalsExp(items.groupId),
  //     ),
  //   ]);
  //
  //   return query.watch().map((rows) {
  //     // read both the entry and the associated category for each row
  //     return rows.map((row) {
  //       return FullData(
  //         row.readTable(users),
  //         row.readTable(items),
  //         row.readTable(groups),
  //       );
  //     }).toList();
  //   });
  // }

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
  Future<int> createUser(String description) {
    return into(users).insert(UsersCompanion.insert(name: description));
  }

  Future<bool> editUser(User user) {
    return update(users).replace(user);
  }

  Future<int> createGroup(String description, String colorName) {
    return into(groups).insert(GroupsCompanion.insert(
      name: description,
      color: colorName,
    ));
  }

  Future<bool> editGroup(Group group) {
    return update(groups).replace(group);
  }

  Future<int> createItem({
    required int groupId,
    required int userId,
    required String name,
    required String value,
    required String target,
  }) {
    return into(items).insert(ItemsCompanion.insert(
      groupId: groupId,
      userId: userId,
      name: name,
      quantity: 1,
      price: double.parse(value),
      targetPercent: double.tryParse(target) ?? 0,
    ));
  }

  // Future<bool> updateItem(Item item) {
  //   return update(items).replace(item);
  // }

  Future<bool> updateItem(Item item, String name, String price, String target) {
    return update(items).replace(item.copyWith(
      name: name,
      price: double.parse(price),
      targetPercent: double.tryParse(target) ?? 0,
    ));
  }

  Future<int> deleteItem(Item item) {
    return (delete(items)..where((t) => t.id.equals(item.id))).go();
  }

  Future<int> getDefaultUser() async {
    if (await userExists().getSingle() == 0) {
      // Create a new default user if it doesn't exist.
      final id = await into(users).insert(UsersCompanion.insert(name: '🚀'));
      return id;
    }

    return (await select(users).get())[0].id;
  }

// Future deleteCategory(Category category) {
//   return transaction<dynamic>(() async {
//     await _resetCategory(category.id);
//     await delete(categories).delete(category);
//   });
// }
}
