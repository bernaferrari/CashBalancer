import 'dart:math';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:cash_balancer/page_analysis/analysis_page.dart';
import 'package:cash_balancer/page_crud/crud_item_page.dart';
import 'package:cash_balancer/page_crud/crud_wallet_page.dart';
import 'package:cash_balancer/page_crud/move_item_page.dart';
import 'package:cash_balancer/page_home/details_page.dart';
import 'package:cash_balancer/page_settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';

final simpleBuilder = SimpleLocationBuilder(routes: {
  '/': (context, state) {
    return const BeamPage(
      key: ValueKey('home'),
      title: 'Cash Balancer',
      child: HomePage(),
    );
  },
  '/settings': (context, state) => BeamerMaterialTransitionPage(
        key: const ValueKey('settings'),
        title: 'Settings',
        child: const SettingsPage(),
        popToNamed: '/',
        fillColor: getScaffoldDialogBackgroundColor(context, 'warmGray'),
      ),
  '/analysis': (context, state) => BeamerMaterialTransitionPage(
        key: const ValueKey('analysis'),
        title: 'Analysis',
        child: const AnalysisPage(),
        popToNamed: '/',
        fillColor: getScaffoldDialogBackgroundColor(context, 'warmGray'),
      ),
  '/addWallet/:userId': (context, state) {
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
  '/editWallet/:walletId': (context, state) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final walletId = int.tryParse(beamState.pathParameters['walletId'] ?? '');

    if (walletId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;
    if (state != null) {
      final String colorName = state.walletsMap[walletId]!.colorName;

      return BeamerMaterialTransitionPage(
        key: ValueKey('editWallet-$walletId'),
        title: AppLocalizations.of(context).editWallet,
        child: CRUDWalletPage(
          userId: state.userId,
          previousWallet: state.walletsMap[walletId]!,
        ),
        fillColor: getScaffoldDialogBackgroundColor(context, colorName),
      );
    } else {
      return beamerLoadingPage();
    }
  },
  '/addItem/:walletId': (context, state) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final walletId = int.tryParse(beamState.pathParameters['walletId'] ?? '');

    if (walletId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;
    if (state != null) {
      final String colorName = state.walletsMap[walletId]!.colorName;

      // Widgets and BeamPages can be mixed!
      return BeamerMaterialTransitionPage(
        key: ValueKey('addItem-$walletId'),
        title: 'Add Item',
        child: CRUDItemPage(
          userId: state.userId,
          previousItem: null,
          colorName: colorName,
          walletId: walletId,
          totalValue: state.totalValue,
          currency: state.settings.currencySymbol,
        ),
        fillColor: getScaffoldDialogBackgroundColor(context, colorName),
      );
    } else {
      return beamerLoadingPage();
    }
  },
  '/editItem/:itemId': (context, state) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final itemId = int.tryParse(beamState.pathParameters['itemId'] ?? '');

    if (itemId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;
    if (state != null && state.allItems.isNotEmpty) {
      final previousItem =
          state.allItems.firstWhere((element) => element.id == itemId);

      return BeamerMaterialTransitionPage(
        key: ValueKey('item-$itemId'),
        title: 'Edit Item',
        child: CRUDItemPage(
          userId: state.userId,
          previousItem: previousItem,
          colorName: previousItem.colorName,
          walletId: previousItem.walletId,
          totalValue: state.totalValue,
          currency: state.settings.currencySymbol,
        ),
        fillColor:
            getScaffoldDialogBackgroundColor(context, previousItem.colorName),
      );
    } else if (state == null) {
      return beamerLoadingPage();
    }
  },
  '/moveItem/:itemId': (context, state) {
    final beamState = context.currentBeamLocation.state as BeamState;
    final itemId = int.tryParse(beamState.pathParameters['itemId'] ?? '');

    if (itemId == null) {
      return const ErrorPage();
    }

    final state = context.read<DataCubit>().state;

    if (state != null && state.allItems.isNotEmpty) {
      final item = state.allItems.firstWhere((element) => element.id == itemId);

      return BeamerMaterialTransitionPage(
        key: ValueKey('moveItem-$itemId'),
        title: 'Move Item',
        popToNamed: '/editItem/$itemId',
        child: MoveItemPage(
          userId: state.userId,
          item: item,
          wallets: state.walletsMap.values.toList(),
          bloc: context.read<DataCubit>(),
          totalValue: state.totalValue,
        ),
        fillColor: getScaffoldDialogBackgroundColor(context, item.colorName),
      );
    } else if (state == null) {
      return beamerLoadingPage();
    }
  }
});

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _routerDelegate = BeamerDelegate(
    notFoundPage: const BeamPage(
      key: ValueKey('home'),
      title: '404',
      child: ErrorPage(),
    ),
    locationBuilder: simpleBuilder,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme(
      bodyText1: GoogleFonts.inter(),
      bodyText2: GoogleFonts.ibmPlexMono(),
      overline: GoogleFonts.ibmPlexMono(),
      headline5: GoogleFonts.rubikMonoOne(),
      headline6: GoogleFonts.rubik(),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.rubik(fontWeight: FontWeight.w700),
      ),
    );

    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.rubik(fontWeight: FontWeight.w700),
      ),
    );

    return RepositoryProvider(
      create: (context) => constructDb(),
      child: BlocProvider<DataCubit>(
        create: (context) {
          final db = RepositoryProvider.of<Database>(context);
          return DataCubit(db);
        },
        child: MaterialApp.router(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff162783),
              secondary: Color(0xff059669),
              // background: Color(0xff18170f),
              // surface: Color(0xff201f15),
            ),
            dialogTheme: DialogTheme(
              backgroundColor: const Color(0xff18170f),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            typography: Typography.material2018(),
            visualDensity: VisualDensity.standard,
            applyElevationOverlayColor: false,
            elevatedButtonTheme: elevatedButtonTheme,
            outlinedButtonTheme: outlinedButtonTheme,
            textButtonTheme: textButtonTheme,
            textTheme: textTheme,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xffe4d75a),
              secondary: Color(0xff5ae492),
              background: Color(0xff121212),
              surface: Color(0xff201f15),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            typography: Typography.material2018(),
            visualDensity: VisualDensity.standard,
            applyElevationOverlayColor: false,
            elevatedButtonTheme: elevatedButtonTheme,
            outlinedButtonTheme: outlinedButtonTheme,
            textButtonTheme: textButtonTheme,
            textTheme: textTheme,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Cash Balancer',
          routerDelegate: _routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: _routerDelegate),
        ),
      ),
    );
  }
}

BeamPage beamerLoadingPage() {
  final _random = Random();
  final colorName =
      tailwindColorsNames[_random.nextInt(tailwindColorsNames.length)];

  return BeamPage(
    key: const ValueKey("Loading Screen"),
    title: "Loading...",
    type: BeamPageType.noTransition,
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          tailwindColors[colorName]![500]!,
        ),
      ),
    ),
  );
}

class BeamerMaterialTransitionPage extends BeamPage {
  final Color? fillColor;

  const BeamerMaterialTransitionPage({
    LocalKey? key,
    required Widget child,
    String title = '',
    String? popToNamed,
    this.fillColor,
  }) : super(
          key: key,
          child: child,
          title: title,
          popToNamed: popToNamed,
          // + all other you might need
        );

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

class SharedAxisPageRoute extends PageRouteBuilder<Object> {
  SharedAxisPageRoute({
    required Widget page,
    required SharedAxisTransitionType transitionType,
    required RouteSettings? settings,
    Color? fillColor,
  }) : super(
          pageBuilder: (context, primaryAnimation, secondaryAnimation) => page,
          settings: settings,
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
              child: child,
              fillColor: fillColor,
            );
          },
        );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

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
