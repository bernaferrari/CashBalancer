import 'package:cash_balancer/database/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

void main() {
  test('Test Moor', () async {
    final db = constructDb();
    await db.delete(db.users).go();

    // Expect everything to be null.
    expect(await db.select(db.users).getSingleOrNull(), null);
    expect(await db.select(db.wallets).getSingleOrNull(), null);
    expect(await db.select(db.items).getSingleOrNull(), null);

    // Test addDefaultUser
    expect((await db.userExists().getSingle()), 0);
    final id = await db.getDefaultUser();
    expect((await db.userExists().getSingle()), 1);

    // Test listening to user
    // (await db.watchItems(id)).map((event) => print("event is $event"));

    final queryUser = db.select(db.users)..where((user) => user.id.equals(id));

    final query = queryUser.join([
      // leftOuterJoin(
      //   db.items,
      //   db.items.userId.equalsExp(db.users.id),
      // ),
      leftOuterJoin(
        db.wallets,
        db.wallets.id.equalsExp(db.items.id),
      ),
    ]);

    final result = await query.get();
    print("result is $result");
    // print(await (db.watchItems(id)));
  });
}
