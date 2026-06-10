import 'package:cash_balancer/database/database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Moor', () async {
    final db = Database(NativeDatabase.memory());
    addTearDown(db.close);

    // beforeOpen creates a default user on first open.
    expect((await db.userExists().getSingle()), 1);
    final id = await db.getDefaultUser();
    expect(id, greaterThan(0));

    await db.delete(db.users).go();

    expect(await db.select(db.users).getSingleOrNull(), null);
    expect(await db.select(db.wallets).getSingleOrNull(), null);
    expect(await db.select(db.items).getSingleOrNull(), null);
    expect((await db.userExists().getSingle()), 0);
  });
}