// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

export 'database/shared.dart';

part 'database.g.dart';

// @DataClassName('TodoEntry')
// class Todos extends Table {
//   IntColumn get id => integer().autoIncrement()();
//
//   TextColumn get content => text()();
//
//   DateTimeColumn get targetDate => dateTime().nullable()();
//
//   IntColumn get category => integer()
//       .nullable()
//       .customConstraint('NULLABLE REFERENCES categories(id)')();
// }

@DataClassName('Kind')
class AssetKind extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get color => text()();
}

@DataClassName('Group')
class AssetGroup extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

@DataClassName('Data')
class AssetData extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get typeId => integer()();

  IntColumn get groupId => integer()();

  TextColumn get name => text()();

  RealColumn get quantity => real()();

  RealColumn get price => real()();

  RealColumn get targetPercent => real()();
}

// @DataClassName('Category')
// class Categories extends Table {
//   IntColumn get id => integer().autoIncrement()();
//
//   TextColumn get description => text().named('desc')();
// }

// class CategoryWithCount {
//   CategoryWithCount(this.category, this.count);
//
//   // can be null, in which case we count how many entries don't have a category
//   final Category category;
//   final int count; // amount of entries in this category
// }
//
// class EntryWithCategory {
//   EntryWithCategory(this.entry, this.category);
//
//   final TodoEntry entry;
//   final Category category;
// }

@UseMoor(
  tables: [AssetKind, AssetGroup, AssetData],
  queries: {
    '_resetCategory': 'UPDATE todos SET category = NULL WHERE category = ?',
    'getGroup': 'SELECT * FROM asset_group',
    'getKind': 'SELECT * FROM asset_kind,',
    'getData': 'SELECT * FROM asset_data',
    // '_categoriesWithCount': '''
    //  SELECT
    //    c.id,
    //    c.desc,
    //    (SELECT COUNT(*) FROM todos WHERE category = c.id) AS amount
    //  FROM categories c
    //  UNION ALL
    //  SELECT null, null, (SELECT COUNT(*) FROM todos WHERE category IS NULL)
    //  ''',
  },
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
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
// Stream<List<EntryWithCategory>> watchEntriesInCategory(Category category) {
//   final query = select(todos).join(
//       [leftOuterJoin(categories, categories.id.equalsExp(todos.category))]);
//
//   if (category != null) {
//     query.where(categories.id.equals(category.id));
//   } else {
//     query.where(categories.id.isNull());
//   }
//
//   return query.watch().map((rows) {
//     // read both the entry and the associated category for each row
//     return rows.map((row) {
//       return EntryWithCategory(
//         row.readTable(todos),
//         row.readTable(categories),
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
  Future<int> createGroup(String description) {
    return into(assetGroup)
        .insert(AssetGroupCompanion.insert(name: description));
  }
//
// Future deleteCategory(Category category) {
//   return transaction<dynamic>(() async {
//     await _resetCategory(category.id);
//     await delete(categories).delete(category);
//   });
// }
}
