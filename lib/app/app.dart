import 'dart:math';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../details_screen/crud_group_page.dart';
import '../details_screen/crud_item_page.dart';
import '../details_screen/details_page.dart';
import '../details_screen/move_item_page.dart';
import '../l10n/l10n.dart';
import '../settings/settings_page.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _routerDelegate = BeamerDelegate(
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context) => BeamPage(
            key: ValueKey('home'),
            title: 'Cash Balancer',
            child: DetailsPage(),
          ),
      '/settings': (context) => BeamerMaterialTransitionPage(
            key: ValueKey('settings'),
            title: 'Settings',
            child: SettingsPage(),
            fillColor: getScaffoldDialogBackgroundColor(context, 'warmGray'),
          ),
      '/addGroup/:userId': (context) {
        final beamState = context.currentBeamLocation.state;
        final userId = int.tryParse(beamState.pathParameters['userId']!)!;
        final state = context.read<DataCubit>().state;
        if (state != null) {
          return BeamerMaterialTransitionPage(
            key: ValueKey('addGroup-$userId'),
            title: 'Add Group',
            child: CRUDGroupPage(userId: state.userId),
          );
        } else {
          return beamerLoadingPage();
        }
      },
      '/editGroup/:groupId': (context) {
        final beamState = context.currentBeamLocation.state;
        final groupId = int.tryParse(beamState.pathParameters['groupId']!)!;

        final state = context.read<DataCubit>().state;
        if (state != null) {
          final String colorName = state.groupsMap[groupId]!.colorName;

          return BeamerMaterialTransitionPage(
            key: ValueKey('editGroup-$groupId'),
            title: 'Add Item',
            child: CRUDGroupPage(
              userId: state.userId,
              previousGroup: state.groupsMap[groupId]!,
            ),
            fillColor: getScaffoldDialogBackgroundColor(context, colorName),
          );
        } else {
          return beamerLoadingPage();
        }
      },
      '/addItem/:groupId/:userId': (context) {
        final beamState = context.currentBeamLocation.state;
        final groupId = int.tryParse(beamState.pathParameters['groupId']!)!;
        final userId = int.tryParse(beamState.pathParameters['userId']!)!;

        final state = context.read<DataCubit>().state;
        if (state != null) {
          final String colorName = state.groupsMap[groupId]!.colorName;

          // Widgets and BeamPages can be mixed!
          return BeamerMaterialTransitionPage(
            key: ValueKey('addItem-$groupId$userId'),
            title: 'Add Item',
            child: CRUDItemPage(
              userId: state.userId,
              previousItem: null,
              colorName: colorName,
              groupId: groupId,
              totalValue: state.totalValue,
            ),
            fillColor: getScaffoldDialogBackgroundColor(context, colorName),
          );
        } else {
          return beamerLoadingPage();
        }
      },
      '/editItem/:itemId': (context) {
        final beamState = context.currentBeamLocation.state;
        final itemId = int.tryParse(beamState.pathParameters['itemId']!)!;

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
              groupId: previousItem.groupId,
              totalValue: state.totalValue,
            ),
            fillColor: getScaffoldDialogBackgroundColor(
                context, previousItem.colorName),
          );
        } else if (state == null) {
          return beamerLoadingPage();
        }
      },
      '/moveItem/:itemId': (context) {
        final beamState = context.currentBeamLocation.state;
        final itemId = int.tryParse(beamState.pathParameters['itemId']!)!;

        // BlocProvider.of<DataCubit>(context).state;
        final state = context.read<DataCubit>().state;

        if (state != null && state.allItems.isNotEmpty) {
          final item =
          state.allItems.firstWhere((element) => element.id == itemId);

          return BeamerMaterialTransitionPage(
            key: ValueKey('moveItem-$itemId'),
            title: 'Move Item',
            popToNamed: '/editItem/$itemId',
            child: MoveItemPage(
              userId: state.userId,
              item: item,
              groups: state.groupsMap.values.toList(),
              bloc: context.read<DataCubit>(),
              totalValue: state.totalValue,
            ),
            fillColor:
                getScaffoldDialogBackgroundColor(context, item.colorName),
          );
        } else if (state == null) {
          return beamerLoadingPage();
        }
      }
    }),
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
        minimumSize: Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.rubik(fontWeight: FontWeight.w700),
      ),
    );

    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(48, 48),
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
            colorScheme: ColorScheme.light(
              primary: Color(0xff162783),
              secondary: Color(0xff168342),
              // background: Color(0xff18170f),
              // surface: Color(0xff201f15),
            ),
            dialogTheme: DialogTheme(
              backgroundColor: Color(0xff18170f),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            accentColor: const Color(0xff5ae492),
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            typography: Typography.material2018(),
            visualDensity: VisualDensity.standard,
            applyElevationOverlayColor: true,
            elevatedButtonTheme: elevatedButtonTheme,
            outlinedButtonTheme: outlinedButtonTheme,
            textButtonTheme: textButtonTheme,
            textTheme: textTheme,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
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
            accentColor: const Color(0xff5ae492),
            typography: Typography.material2018(),
            visualDensity: VisualDensity.standard,
            applyElevationOverlayColor: true,
            elevatedButtonTheme: elevatedButtonTheme,
            outlinedButtonTheme: outlinedButtonTheme,
            textButtonTheme: textButtonTheme,
            textTheme: textTheme,
          ),
          localizationsDelegates: [
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
    key: ValueKey("Loading Screen"),
    title: "Loading...",
    type: BeamPageType.noTransition,
    child: Center(
      child: Container(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          tailwindColors[colorName]![500]!,
        ),
      )),
    ),
  );
}

class BeamerMaterialTransitionPage extends BeamPage {
  final Color? fillColor;

  BeamerMaterialTransitionPage({
    LocalKey? key,
    required Widget child,
    String title = 'hello',
    String popToNamed = '/',
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
    transitionsBuilder: (context,
        primaryAnimation,
        secondaryAnimation,
        child,) {
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
