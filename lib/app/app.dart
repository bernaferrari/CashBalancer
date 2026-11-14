import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;

import '../l10n/l10n.dart';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:cash_balancer/page_analysis/analysis_page.dart';
import 'package:cash_balancer/page_crud/crud_item_page.dart';
import 'package:cash_balancer/page_crud/crud_wallet_page.dart';
import 'package:cash_balancer/page_crud/move_item_page.dart';
import 'package:cash_balancer/page_home/details_page.dart';
import 'package:cash_balancer/page_rebalance/rebalance_page.dart';
import 'package:cash_balancer/page_settings/settings_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/delete_actions.dart';

final simpleBuilder = RoutesLocationBuilder(
  routes: {
    '/': (context, state, obj) {
      return BeamPage(
        key: const ValueKey('home'),
        title: context.l10n.appTitle,
        child: const HomePage(),
      );
    },
    '/settings': (context, state, obj) => BeamerMaterialTransitionPage(
      key: const ValueKey('settings'),
      title: context.l10n.settings,
      child: const SettingsPage(),
      popToNamed: '/',
      fillColor: getScaffoldDialogBackgroundColor(context, 'stone'),
    ),
    '/analysis': (context, state, obj) => BeamerMaterialTransitionPage(
      key: const ValueKey('analysis'),
      title: context.l10n.allItems,
      child: const AnalysisPage(),
      popToNamed: '/',
      fillColor: getScaffoldDialogBackgroundColor(context, 'stone'),
    ),
    '/rebalance': (context, state, obj) => BeamerMaterialTransitionPage(
      key: const ValueKey('rebalance'),
      title: context.l10n.rebalanceCalculator,
      child: const RebalancePage(),
      popToNamed: '/',
      fillColor: getScaffoldDialogBackgroundColor(context, 'emerald'),
    ),
    '/addWallet/:userId': (context, state, obj) => _dataPage(
      context,
      'addWallet',
      state.pathParameters['userId'],
      context.l10n.addWallet,
      (context, state, id) {
        if (!state.portfolios.any((p) => p.id == id)) {
          return const ErrorPage();
        }
        return CRUDWalletPage(userId: id);
      },
    ),
    '/editWallet/:walletId': (context, state, obj) => _dataPage(
      context,
      'editWallet',
      state.pathParameters['walletId'],
      context.l10n.editWallet,
      (context, state, id) {
        if (!state.walletsMap.containsKey(id)) return const ErrorPage();
        return CRUDWalletPage(
          userId: state.userId,
          previousWallet: state.walletsMap[id]!,
        );
      },
      walletColor: (state, id) => state.walletsMap[id]?.colorName,
    ),
    '/addItem/:walletId': (context, state, obj) => _dataPage(
      context,
      'addItem',
      state.pathParameters['walletId'],
      context.l10n.addAsset,
      (context, state, id) {
        if (!state.walletsMap.containsKey(id)) return const ErrorPage();
        return CRUDItemPage(
          userId: state.userId,
          walletId: id,
          colorName: state.walletsMap[id]!.colorName,
          totalValue: state.totalValue,
          currency: state.settings.currencySymbol,
        );
      },
      walletColor: (state, id) => state.walletsMap[id]?.colorName,
    ),
    '/editItem/:itemId': (context, state, obj) => _dataPage(
      context,
      'editItem',
      state.pathParameters['itemId'],
      context.l10n.editAsset,
      (context, state, id) {
        final item = state.allItems.where((item) => item.id == id).firstOrNull;
        if (item == null) return const ErrorPage();
        return CRUDItemPage(
          userId: state.userId,
          previousItem: item,
          walletId: item.walletId,
          colorName: item.colorName,
          totalValue: state.totalValue,
          currency: state.settings.currencySymbol,
        );
      },
      walletColor: (state, id) =>
          state.allItems.where((item) => item.id == id).firstOrNull?.colorName,
    ),
    '/moveItem/:itemId': (context, state, obj) => _dataPage(
      context,
      'moveItem',
      state.pathParameters['itemId'],
      context.l10n.move,
      (context, state, id) {
        final item = state.allItems.where((item) => item.id == id).firstOrNull;
        if (item == null) return const ErrorPage();
        return MoveItemPage(
          item: item,
          wallets: state.walletsMap.values.toList(),
          bloc: context.read<DataCubit>(),
        );
      },
      walletColor: (state, id) =>
          state.allItems.where((item) => item.id == id).firstOrNull?.colorName,
    ),
  },
);

class const App({super.key, final Database? db}) extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _routerDelegate = BeamerDelegate(
    notFoundPage: const BeamPage(key: ValueKey('home'), child: ErrorPage()),
    locationBuilder: simpleBuilder.call,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'IBM Plex Mono',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontFamily: 'IBM Plex Mono',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );

    final textButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700),
      ),
    );

    OutlinedButtonThemeData buildOutlinedButtonTheme(
      Color borderColor,
    ) => OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700),
      ),
    );

    return RepositoryProvider<Database>(
      create: (context) => widget.db ?? constructDb(),
      dispose: (db) {
        if (widget.db == null) {
          db.close();
        }
      },
      child: BlocProvider<DataCubit>(
        create: (context) {
          final db = RepositoryProvider.of<Database>(context);
          return DataCubit(db);
        },
        child: BlocSelector<DataCubit, FullData?, (ThemeMode, Locale?)>(
          selector: (state) {
            final themeMode = switch (state?.settings.themeMode) {
              1 => ThemeMode.light,
              2 => ThemeMode.dark,
              _ => ThemeMode.system,
            };
            final langCode = state?.settings.languageCode;
            final locale = (langCode != null && langCode.isNotEmpty)
                ? Locale(langCode)
                : null;
            return (themeMode, locale);
          },
          builder: (context, appPrefs) => MaterialApp.router(
            themeMode: appPrefs.$1,
            locale: appPrefs.$2,
            theme: ThemeData(
              scaffoldBackgroundColor: TailwindColor.slate.palette.s50,
              colorScheme: ColorScheme.light(
                primary: TailwindColor.emerald.palette.s700,
                onPrimary: Colors.white,
                secondary: TailwindColor.emerald.palette.s600,
                onSecondary: Colors.white,
                surface: Colors.white,
                onSurface: TailwindColor.slate.palette.s900,
                surfaceTint: Colors.transparent,
                onSurfaceVariant: TailwindColor.slate.palette.s600,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: TailwindColor.emerald.palette.s600,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: const StadiumBorder(),
              ),
              dividerTheme: DividerThemeData(
                color: TailwindColor.slate.palette.s900.withValues(alpha: 0.08),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: TailwindColor.sky.palette.s500,
                foregroundColor: TailwindColor.slate.palette.s900,
              ),
              typography: Typography.material2021(),
              visualDensity: VisualDensity.standard,
              applyElevationOverlayColor: false,
              elevatedButtonTheme: elevatedButtonTheme,
              outlinedButtonTheme: buildOutlinedButtonTheme(
                TailwindColor.slate.palette.s900.withValues(alpha: 0.14),
              ),
              textButtonTheme: textButtonTheme,
              textTheme: textTheme,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: TailwindColor.zinc.palette.s950,
              colorScheme: ColorScheme.dark(
                primary: TailwindColor.emerald.palette.s400,
                onPrimary: TailwindColor.zinc.palette.s950,
                secondary: TailwindColor.emerald.palette.s400,
                onSecondary: TailwindColor.zinc.palette.s950,
                surface: TailwindColor.zinc.palette.s900,
                onSurface: TailwindColor.zinc.palette.s100,
                surfaceTint: Colors.transparent,
                onSurfaceVariant: TailwindColor.zinc.palette.s400,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: TailwindColor.zinc.palette.s900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: TailwindColor.emerald.palette.s400,
                foregroundColor: TailwindColor.zinc.palette.s950,
                elevation: 2,
                shape: const StadiumBorder(),
              ),
              dividerTheme: DividerThemeData(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              typography: Typography.material2021(),
              visualDensity: VisualDensity.standard,
              applyElevationOverlayColor: false,
              elevatedButtonTheme: elevatedButtonTheme,
              outlinedButtonTheme: buildOutlinedButtonTheme(
                Colors.white.withValues(alpha: 0.14),
              ),
              textButtonTheme: textButtonTheme,
              textTheme: textTheme,
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) => context.l10n.appTitle,
            routerDelegate: _routerDelegate,
            routeInformationParser: BeamerParser(),
            backButtonDispatcher: BeamerBackButtonDispatcher(
              delegate: _routerDelegate,
            ),
          ),
        ),
      ),
    );
  }
}

BeamPage _dataPage(
  BuildContext context,
  String route,
  String? parameter,
  String title,
  Widget Function(BuildContext, FullData, int) build, {
  String? Function(FullData, int)? walletColor,
}) {
  final id = int.tryParse(parameter ?? '');
  return BeamPage(
    key: ValueKey('$route-$id'),
    title: title,
    popToNamed: '/',
    child: _DataRouteContent(id, build, walletColor),
    routeBuilder: (context, settings, child) => PageRouteBuilder<Object>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
    ),
  );
}

class const _DataRouteContent(
  final int? id,
  final Widget Function(BuildContext, FullData, int) resolve,
  final String? Function(FullData, int)? walletColor,
) extends StatefulWidget {
  @override
  State<_DataRouteContent> createState() => _DataRouteContentState();
}

class _DataRouteContentState extends State<_DataRouteContent> {
  FullData? _lastAvailable;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!;
    final id = widget.id;
    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, data) {
        final closing = route.animation!.status == AnimationStatus.reverse;
        // Drift can publish the deletion before Navigator starts reversing.
        if ((closing || isDeletingRoute(route)) && _lastAvailable != null) {
          data = _lastAvailable;
        }
        final child = id == null
            ? const ErrorPage()
            : data == null
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : widget.resolve(context, data, id);
        if (child is! ErrorPage && data != null) _lastAvailable = data;
        final color = id == null || data == null
            ? null
            : widget.walletColor?.call(data, id);
        return SharedAxisTransition(
          animation: route.animation!,
          secondaryAnimation: route.secondaryAnimation!,
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: color == null
              ? null
              : getScaffoldDialogBackgroundColor(context, color),
          child: child,
        );
      },
    );
  }
}

class const BeamerMaterialTransitionPage({
  super.key,
  required super.child,
  String super.title = '',
  super.popToNamed,
  final Color? fillColor,
}) extends BeamPage {
  @override
  Route createRoute(BuildContext context) {
    return SharedAxisPageRoute(
      page: child,
      transitionType: SharedAxisTransitionType.horizontal,
      settings: this,
      fillColor: fillColor,
    );
  }
}

class SharedAxisPageRoute({
  required Widget page,
  required SharedAxisTransitionType transitionType,
  required super.settings,
  Color? fillColor,
}) extends PageRouteBuilder<Object> {
  this
    : super(
        pageBuilder: (context, primaryAnimation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, primaryAnimation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: transitionType,
                fillColor: fillColor,
                child: child,
              );
            },
      );
}

class const ErrorPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.l10n.pageNotFound,
              style: TextStyle(fontFamily: 'IBM Plex Mono', fontSize: 44),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(context.l10n.goHome),
              onPressed: () {
                Beamer.of(context).beamToNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
