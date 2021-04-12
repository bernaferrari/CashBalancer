import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../home_screen/home_screen.dart';
import '../l10n/l10n.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: const Color(0xff5ae492),
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        visualDensity: VisualDensity.standard,
        typography: Typography.material2018(),
        applyElevationOverlayColor: true,
        colorScheme: ColorScheme.dark(
          primary: Color(0xffe4d75a),
          secondary: Color(0xff5ae492),
          background: Color(0xff18170f),
          surface: Color(0xff201f15),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Color(0xff18170f),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyText1: GoogleFonts.inter(),
          bodyText2: GoogleFonts.ibmPlexMono(),
          overline: GoogleFonts.ibmPlexMono(),
          headline5: GoogleFonts.rubikMonoOne(),
          headline6: GoogleFonts.rubik(),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Cash Balancer',
      home: RepositoryProvider<Database>(
        create: (context) => constructDb(),
        child: BlocProvider<DataBloc>(
          create: (context) => DataBloc(),
          // child: DetailsPage(data[0].name, data[0].data), //
          child: HomeScreen(),
        ),
      ),
    );
  }
}
