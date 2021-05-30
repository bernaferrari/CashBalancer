import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../details_screen/details_page.dart';
import '../details_screen/item_dialog.dart';
import '../l10n/l10n.dart';
import '../settings/settings_page.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _routerDelegate = BeamerDelegate(
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context) => DetailsPage(),
      '/settings': (context) => SettingsPage(),
      '/addItem/:groupId/:userId': (context) {
        final beamState = context.currentBeamLocation.state;
        final groupId = int.tryParse(beamState.pathParameters['groupId']!)!;
        final userId = int.tryParse(beamState.pathParameters['userId']!)!;

        // Widgets and BeamPages can be mixed!
        return BeamPage(
          key: ValueKey('addItem-$groupId$userId'),
          title: 'Add Item',
          popToNamed: '/',
          type: BeamPageType.cupertino,
          child: AddItemPage(groupId: groupId, userId: userId),
        );
      },
      '/editItem/:itemId': (context) {
        final beamState = context.currentBeamLocation.state;
        final itemId = int.tryParse(beamState.pathParameters['itemId']!)!;

        // Widgets and BeamPages can be mixed!
        return BeamPage(
          key: ValueKey('item-$itemId'),
          title: 'Item #$itemId',
          popToNamed: '/',
          type: BeamPageType.cupertino,
          child: EditItemPage(itemId: itemId),
        );
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
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
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
