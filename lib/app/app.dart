import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../details_screen/details_page.dart';
import '../l10n/l10n.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _routerDelegate = BeamerRouterDelegate(
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context) => DetailsPage(),
      '/settings': (context) => DetailsPage(),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    return BlocProvider<DataBloc>(
      create: (context) => DataBloc(),
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
          applyElevationOverlayColor: true,
          elevatedButtonTheme: elevatedButtonTheme,
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
        routeInformationParser: BeamerRouteInformationParser(),
        backButtonDispatcher:
            BeamerBackButtonDispatcher(delegate: _routerDelegate),
      ),
    );
  }
}
