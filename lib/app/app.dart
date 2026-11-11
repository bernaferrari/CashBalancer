import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:cash_balancer/page_analysis/analysis_page.dart';
import 'package:cash_balancer/page_crud/crud_item_page.dart';
import 'package:cash_balancer/page_crud/crud_wallet_page.dart';
import 'package:cash_balancer/page_crud/move_item_page.dart';
import 'package:cash_balancer/page_home/details_page.dart';
import 'package:cash_balancer/page_rebalance/rebalance_page.dart';
import 'package:cash_balancer/page_settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';
import '../gen_l10n/app_localizations.dart';

final simpleBuilder = RoutesLocationBuilder(routes: {
  '/': (context, state, obj) {
    return const BeamPage(
      key: ValueKey('home'),
      title: 'Cash Balancer',
      child: HomePage(),
    );
  },
  '/settings': (context, state, obj) => BeamerMaterialTransitionPage(
        key: const ValueKey('settings'),
        title: 'Settings',
        child: const SettingsPage(),
        popToNamed: '/',
        fillColor: getScaffoldDialogBackgroundColor(context, 'stone'),
      ),
  '/analysis': (context, state, obj) => BeamerMaterialTransitionPage(
        key: const ValueKey('analysis'),
        title: 'Analysis',
        child: const AnalysisPage(),
        popToNamed: '/',
        fillColor: getScaffoldDialogBackgroundColor(context, 'stone'),
      ),
  '/rebalance': (context, state, obj) => BeamerMaterialTransitionPage(
        key: const ValueKey('rebalance'),
        title: 'Rebalance',
        child: const RebalancePage(),
        popToNamed: '/',
        fillColor: getScaffoldDialogBackgroundColor(context, 'emerald'),
      ),
  '/addWallet/:userId': (context, state, obj) {
    final beamState = context.currentBeamLocation.state as BeamState;

    final userId = int.tryParse(beamState.pathParameters['userId'] ?? '');
    if (userId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;
    if (state != null) {
      return BeamerMaterialTransitionPage(
        key: ValueKey('addWallet-$userId'),
        title: AppLocalizations.of(context).addWallet,
        child: CRUDWalletPage(userId: state.userId),
        popToNamed: '/',
      );
    } else {
      return beamerLoadingPage();
    }
  },
  '/editWallet/:walletId': (context, state, obj) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final walletId = int.tryParse(beamState.pathParameters['walletId'] ?? '');

    if (walletId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;
    if (state != null) {
      final wallet = state.walletsMap[walletId];
      if (wallet != null) {
        return BeamerMaterialTransitionPage(
          key: ValueKey('editWallet-$walletId'),
          title: AppLocalizations.of(context).editWallet,
          child: CRUDWalletPage(
            userId: state.userId,
            previousWallet: wallet,
          ),
          fillColor: getScaffoldDialogBackgroundColor(context, wallet.colorName),
        );
      } else {
        return const ErrorPage();
      }
    } else {
      return beamerLoadingPage();
    }
  },
  '/addItem/:walletId': (context, state, obj) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final walletId = int.tryParse(beamState.pathParameters['walletId'] ?? '');

    if (walletId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;
    if (state != null) {
      final wallet = state.walletsMap[walletId];
      if (wallet != null) {
        // Widgets and BeamPages can be mixed!
        return BeamerMaterialTransitionPage(
          key: ValueKey('addItem-$walletId'),
          title: 'Add Item',
          child: CRUDItemPage(
            userId: state.userId,
            previousItem: null,
            colorName: wallet.colorName,
            walletId: walletId,
            totalValue: state.totalValue,
            currency: state.settings.currencySymbol,
          ),
          fillColor: getScaffoldDialogBackgroundColor(context, wallet.colorName),
        );
      } else {
        return const ErrorPage();
      }
    } else {
      return beamerLoadingPage();
    }
  },
  '/editItem/:itemId': (context, state, obj) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final itemId = int.tryParse(beamState.pathParameters['itemId'] ?? '');

    if (itemId == null) {
      return const ErrorPage();
    }

    final dataState = context.read<DataCubit>().state;
    if (dataState == null) {
      return beamerLoadingPage();
    }

    final previousItem =
        dataState.allItems.where((element) => element.id == itemId).firstOrNull;
    if (previousItem == null) {
      return const ErrorPage();
    }

    return BeamerMaterialTransitionPage(
      key: ValueKey('item-$itemId'),
      title: 'Edit Item',
      child: CRUDItemPage(
        userId: dataState.userId,
        previousItem: previousItem,
        colorName: previousItem.colorName,
        walletId: previousItem.walletId,
        totalValue: dataState.totalValue,
        currency: dataState.settings.currencySymbol,
      ),
      fillColor:
          getScaffoldDialogBackgroundColor(context, previousItem.colorName),
    );
  },
  '/moveItem/:itemId': (context, state, obj) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final itemId = int.tryParse(beamState.pathParameters['itemId'] ?? '');

    if (itemId == null) {
      return const ErrorPage();
    }

    final dataState = context.read<DataCubit>().state;
    if (dataState == null) {
      return beamerLoadingPage();
    }

    final item =
        dataState.allItems.where((element) => element.id == itemId).firstOrNull;
    if (item == null) {
      return const ErrorPage();
    }

    return BeamerMaterialTransitionPage(
      key: ValueKey('moveItem-$itemId'),
      title: 'Move Item',
      popToNamed: '/editItem/$itemId',
      child: MoveItemPage(
        item: item,
        wallets: dataState.walletsMap.values.toList(),
        bloc: context.read<DataCubit>(),
      ),
      fillColor: getScaffoldDialogBackgroundColor(context, item.colorName),
    );
  },
});

class const App({super.key, final Database? db}) extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _routerDelegate = BeamerDelegate(
    notFoundPage: const BeamPage(
      key: ValueKey('home'),
      title: '404',
      child: ErrorPage(),
    ),
    locationBuilder: simpleBuilder.call,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme(
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium:
          GoogleFonts.ibmPlexMono(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
      ),
      headlineSmall:
          GoogleFonts.rubikMonoOne(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: GoogleFonts.rubik(fontSize: 20, fontWeight: FontWeight.w500),
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
        textStyle: GoogleFonts.rubik(fontWeight: FontWeight.w700),
      ),
    );

    OutlinedButtonThemeData buildOutlinedButtonTheme(Color borderColor) =>
        OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 48),
            side: BorderSide(color: borderColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.rubik(fontWeight: FontWeight.w700),
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
              scaffoldBackgroundColor: Colors.white,
              colorScheme: const ColorScheme.light(
                primary: Color.from(
                  alpha: 1,
                  red: 0.118,
                  green: 0.161,
                  blue: 0.506,
                  colorSpace: ColorSpace.displayP3,
                ),
                secondary: Color.from(
                  alpha: 1,
                  red: 0.128,
                  green: 0.578,
                  blue: 0.412,
                  colorSpace: ColorSpace.displayP3,
                ),
              ),
              dialogTheme: DialogThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color.from(
                  alpha: 1,
                  red: 0.128,
                  green: 0.578,
                  blue: 0.412,
                  colorSpace: ColorSpace.displayP3,
                ),
                foregroundColor: Colors.white,
                shape: StadiumBorder(),
              ),
              dividerTheme: DividerThemeData(
                color: Colors.black.withValues(alpha: 0.08),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.from(
                  alpha: 1,
                  red: 0.158,
                  green: 0.720,
                  blue: 0.985,
                  colorSpace: ColorSpace.displayP3,
                ),
              ),
              typography: Typography.material2021(),
              visualDensity: VisualDensity.standard,
              applyElevationOverlayColor: false,
              elevatedButtonTheme: elevatedButtonTheme,
              outlinedButtonTheme: buildOutlinedButtonTheme(
                  Colors.black.withValues(alpha: 0.12)),
              textButtonTheme: textButtonTheme,
              textTheme: textTheme,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xff121212),
              colorScheme: const ColorScheme.dark(
                primary: Color.from(
                  alpha: 1,
                  red: 0.888,
                  green: 0.844,
                  blue: 0.368,
                  colorSpace: ColorSpace.displayP3,
                ),
                secondary: Color.from(
                  alpha: 1,
                  red: 0.422,
                  green: 0.888,
                  blue: 0.588,
                  colorSpace: ColorSpace.displayP3,
                ),
                surface: Color(0xff201f15),
              ),
              dialogTheme: DialogThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color.from(
                  alpha: 1,
                  red: 0.422,
                  green: 0.888,
                  blue: 0.588,
                  colorSpace: ColorSpace.displayP3,
                ),
                foregroundColor: Colors.black,
                shape: StadiumBorder(),
              ),
              dividerTheme: DividerThemeData(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              typography: Typography.material2021(),
              visualDensity: VisualDensity.standard,
              applyElevationOverlayColor: false,
              elevatedButtonTheme: elevatedButtonTheme,
              outlinedButtonTheme: buildOutlinedButtonTheme(
                  Colors.white.withValues(alpha: 0.12)),
              textButtonTheme: textButtonTheme,
              textTheme: textTheme,
            ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Cash Balancer',
          routerDelegate: _routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: _routerDelegate),
          ),
        ),
      ),
    );
  }
}

BeamPage beamerLoadingPage() {
  final color = TailwindColor.random().palette.s500;

  return BeamPage(
    key: const ValueKey("Loading Screen"),
    title: "Loading...",
    type: BeamPageType.noTransition,
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    ),
  );
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
          transitionsBuilder: (
            context,
            primaryAnimation,
            secondaryAnimation,
            child,
          ) {
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
              "404",
              style: GoogleFonts.ibmPlexMono(fontSize: 44),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Go to /"),
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
