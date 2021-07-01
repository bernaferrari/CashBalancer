// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'dart:collection';
import 'dart:ui';

import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import '../util/get_color_by_quantile.dart';
import 'data.dart';

export 'database/shared.dart';

part 'database.g.dart';

class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  TextColumn get name => text()();

  TextColumn get colorName => text()();

  RealColumn get targetPercent => real()();
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
      onUpgrade: (m, from, to) async {},
      beforeOpen: (details) async {
        if (details.wasCreated) {
          await into(users).insert(UsersCompanion.insert(name: 'Wallet #1'));
        }
      },
    );
  }

  // Users, Groups : [Items]
  Stream<FullData> watchGroups(int userId) {
    final groupsQuery = select(groups)
      ..where((item) => item.userId.equals(userId));

    final itemsQuery = select(items)
      ..where((item) => item.userId.equals(userId));

    final rxPrefs = RxSharedPreferences.getInstance();
    final relativeTargetStream = rxPrefs.getBoolStream('relativeTarget');
    final currencySymbolStream = rxPrefs.getStringStream('currencySymbol');
    final sortBy = rxPrefs.getIntStream('sortBy');

    final settingsData = Rx.combineLatest3<bool?, String?, int?, SettingsData>(
        relativeTargetStream, currencySymbolStream, sortBy, (
      relativeTarget,
      currencySymbol,
      sortBy,
    ) {
      // if (relativeTarget == null || currencySymbol == null || sortBy == null) {
      //   return null;
      // }

      print(
          "relativeTarget: $relativeTarget, currencySymbol: $currencySymbol, sortBy: $sortBy");

      return SettingsData(
        relativeTarget: relativeTarget ?? false,
        currencySymbol: currencySymbol ?? "\$",
        sortBy: sortBy ?? 0,
      );
    });

    return Rx.combineLatest3<List<Group>, List<Item>, SettingsData, FullData>(
        groupsQuery.watch(), itemsQuery.watch(), settingsData,
        (groupList, itemsList, settings) {
      final List<Item> sortedItems = [...itemsList]..sort((a, b) {
          return (b.price * b.quantity).compareTo((a.price * a.quantity));
        });
      final Map<int, List<Item>> groupedItems = groupItemByGroupID(sortedItems);

      final groupsMap = <int, GroupData>{};
      double totalValue = 0;
      for (final group in groupList) {
        final double groupValue;
        if (groupedItems[group.id] != null) {
          groupValue = groupedItems[group.id]!
              .fold(0, (a, b) => a + (b.price * b.quantity));
        } else {
          groupValue = 0;
        }

        totalValue += groupValue;

        groupsMap[group.id] = GroupData(group, groupValue);
      }

      final Map<int, Color> colors =
          getColorByQuantile(groupedItems, groupsMap, sortedItems);

      final allItemData = sortedItems
          .map((d) => ItemData(
                item: d,
                colorName: groupsMap[d.groupId]!.colorName,
                color: colors[d.id]!,
              ))
          .toList();

      // Keep the Groups sorted, so the front can just display them.
      final List<GroupData> sortedGroupsList;
      if (settings.sortBy == 0) {
        sortedGroupsList = groupsMap.values.toList()
          ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
      } else {
        sortedGroupsList = groupsMap.values.toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }

      final LinkedHashMap<int, GroupData> sortedGroupsMap = LinkedHashMap();

      for (var group in sortedGroupsList) {
        sortedGroupsMap[group.id] = group;
      }

      final Map<int, List<ItemData>> groupedItemData =
          groupItemDataByGroupID(allItemData);

      return FullData(
        userId: userId,
        totalValue: totalValue,
        allItems: allItemData,
        groupedItems: groupedItemData,
        groupsMap: sortedGroupsMap,
        settings: settings,
      );
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

  Map<int, List<Item>> groupItemByGroupID(List<Item> itemList) {
    final groupedList = <int, List<Item>>{};

    for (int i = 0; i < itemList.length; i++) {
      final groupId = itemList[i].groupId;

      if (groupedList[groupId] != null) {
        groupedList[groupId]!.add(itemList[i]);
      } else {
        groupedList[groupId] = [itemList[i]];
      }
    }

    return groupedList;
  }

  Map<int, List<ItemData>> groupItemDataByGroupID(List<ItemData> itemList) {
    final groupedList = <int, List<ItemData>>{};

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

  Future<int> createUser(String description) {
    return into(users).insert(UsersCompanion.insert(name: description));
  }

  Future<bool> editUser(User user) {
    return update(users).replace(user);
  }

  Future<int> createGroup({
    required int id,
    required String name,
    required String colorName,
    required double targetPercent,
  }) {
    return into(groups).insert(GroupsCompanion.insert(
      userId: id,
      name: name,
      colorName: colorName,
      targetPercent: targetPercent,
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
      targetPercent: double.tryParse(target) ?? -1,
    ));
  }

  Future<bool> updateItem({
    required Item item,
    required String name,
    required String price,
    required String target,
  }) {
    return update(items).replace(item.copyWith(
      name: name,
      price: double.parse(price),
      targetPercent: double.tryParse(target) ?? -1,
    ));
  }

  Future<bool> updateItemGroup({
    required Item item,
    required int groupId,
  }) {
    return update(items).replace(item.copyWith(groupId: groupId));
  }

  Future<int> deleteItem(Item item) {
    return (delete(items)..where((t) => t.id.equals(item.id))).go();
  }

  Future<void> deleteGroup(int groupId) async {
    await (delete(items)..where((t) => t.groupId.equals(groupId))).go();
    await (delete(groups)..where((t) => t.id.equals(groupId))).go();
  }

  Future<int> getDefaultUser() async => (await select(users).get())[0].id;

  Future<Item?> getItemFromId(int id) async {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
