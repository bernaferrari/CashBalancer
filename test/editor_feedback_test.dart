import 'package:cash_balancer/app/theme.dart';
import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/l10n/l10n.dart';
import 'package:cash_balancer/page_crud/crud_item_page.dart';
import 'package:cash_balancer/util/numbers.dart';
import 'package:cash_balancer/widgets/delete_actions.dart';
import 'package:cash_balancer/widgets/ledger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _EmptyDataCubit extends Fake implements DataCubit {
  @override
  FullData? get state => null;

  @override
  Stream<FullData?> get stream => const Stream.empty();
}

Widget _app(Widget home, {Locale? locale, bool accessibleNavigation = false}) =>
    MaterialApp(
      theme: buildTheme(Brightness.light),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: accessibleNavigation
          ? (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(accessibleNavigation: true),
              child: child!,
            )
          : null,
      home: home,
    );

void main() {
  Future<void> openAssetEditor(
    WidgetTester tester, {
    Locale? locale,
    double width = 420,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(
        BlocProvider<DataCubit>.value(
          value: _EmptyDataCubit(),
          child: const CRUDItemPage(
            colorName: 'sky',
            totalValue: 0,
            walletId: 1,
            userId: 1,
            currency: r'$',
          ),
        ),
        locale: locale,
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('the asset editor works on a narrow screen in $locale', (
      tester,
    ) async {
      await openAssetEditor(tester, locale: locale, width: 320);
      final context = tester.element(find.byType(CRUDItemPage));
      expect(Localizations.localeOf(context), locale);
      final strings = context.l10n;
      expect(find.text(strings.balanceOnly), findsOneWidget);
      final tenPercent = formatPercent(10, locale.toString());
      final preset = find.text(tenPercent);
      await tester.tap(preset.hitTestable());
      await tester.pumpAndSettle();
      expect(find.text(strings.targetAssigned(tenPercent)), findsOneWidget);
      expect(strings.deleted('Asset 42'), contains('Asset 42'));
    });
  }

  test('percentages follow local number conventions', () {
    expect(formatPercent(10.5, 'en'), '10.5%');
    expect(formatPercent(10.5, 'fr'), '10,5\u00a0%');
    expect(formatPercent(10.5, 'tr'), '%10,5');
  });

  testWidgets('None and 10% animate the allocation in both directions', (
    tester,
  ) async {
    await openAssetEditor(tester);
    final bar = find.byType(AllocationBar);
    final segment = find.descendant(
      of: bar,
      matching: find.byKey(const ValueKey<Object>('this')),
    );
    double width() =>
        segment.evaluate().isEmpty ? 0 : tester.getSize(segment).width;
    final targetWidth = tester.getSize(bar).width * 0.1;

    expect(width(), 0);
    await tester.tap(find.text('10%'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(width(), allOf(greaterThan(0), lessThan(targetWidth)));
    await tester.pumpAndSettle();
    expect(width(), closeTo(targetWidth, 0.01));

    await tester.tap(find.text('None'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(width(), allOf(greaterThan(0), lessThan(targetWidth)));
    await tester.pumpAndSettle();
    expect(width(), 0);
  });

  testWidgets('cash mode resizes the amount row and keeps the entered values', (
    tester,
  ) async {
    await openAssetEditor(tester);
    Finder field(String label) => find.byWidgetPredicate(
      (widget) =>
          widget is InputDecorator && widget.decoration.labelText == label,
    );
    final toggle = find.text('Track as a cash balance');
    final price = field('Unit price');
    final quantity = field('Quantity');
    final balance = field('Balance');
    final unitsWidth = tester.getSize(price).width;
    await tester.enterText(quantity, '8');
    await tester.tap(toggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final widthWhileGrowing = tester.getSize(balance).width;
    await tester.pumpAndSettle();
    final fullWidth = tester.getSize(balance).width;
    expect(
      widthWhileGrowing,
      allOf(greaterThan(unitsWidth), lessThan(fullWidth)),
    );
    expect(quantity, findsNothing);

    await tester.tap(toggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      tester.getSize(price).width,
      allOf(greaterThan(unitsWidth), lessThan(fullWidth)),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(price).width, unitsWidth);
    expect(
      find.descendant(of: quantity, matching: find.text('8')),
      findsOneWidget,
    );
  });

  Future<void> openDeletionSnackbar(
    WidgetTester tester,
    Future<void> Function() undo, {
    bool accessibleNavigation = false,
  }) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDeleted(context, 'Savings', undo),
              child: const Text('Show deletion'),
            ),
          ),
        ),
        accessibleNavigation: accessibleNavigation,
      ),
    );
    await tester.tap(find.text('Show deletion'));
    await tester.pumpAndSettle();
    expect(find.text('Deleted Savings'), findsOneWidget);
  }

  testWidgets('the deletion snackbar gives Undo four seconds', (tester) async {
    await openDeletionSnackbar(tester, () async {});
    await tester.pump(const Duration(milliseconds: 3500));
    expect(find.text('Undo'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('accessible navigation keeps the Undo action available', (
    tester,
  ) async {
    var restored = false;
    await openDeletionSnackbar(tester, () async {
      restored = true;
    }, accessibleNavigation: true);
    await tester.pump(const Duration(seconds: 5));
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(restored, isTrue);
    expect(find.byType(SnackBar), findsNothing);
  });
}
