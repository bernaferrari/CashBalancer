import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details_page.dart';
import 'tailwind_colors.dart';
import 'util/row_column_spacer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
        typography: Typography.material2018(),
        colorScheme: ColorScheme.dark(),
        textTheme: TextTheme(
          bodyText1: GoogleFonts.inter(),
          bodyText2: GoogleFonts.ibmPlexMono(),
          overline: GoogleFonts.ibmPlexMono(),
          headline5: GoogleFonts.rubikMonoOne(),
          headline6: GoogleFonts.rubik(),
        ),
      ),
      home: HomePage(),
    );
  }
}

const assetKinds = {
  'CDB': AssetKind('1', 'CDB', 'rose'),
  'Stock': AssetKind('2', 'Stock', 'blue'),
  'Crypto': AssetKind('2', 'Stock', 'yellow'),
};

const localStock = AssetGroup('Monetus', 'rose', [
  AssetData("B3SA3", "Stock", 1, 100),
  AssetData("BBDC4", "Stock", 1, 100),
  AssetData("BPAC11", "Stock", 1, 100),
  AssetData("CSAN3", "Stock", 1, 100),
  AssetData("CSNA3", "Stock", 1, 100),
  AssetData("JBBS3", "Stock", 1, 125),
  AssetData("KLBN11", "Stock", 1, 100),
  AssetData("PRIO3", "Stock", 1, 100),
  AssetData("VALE3", "Stock", 1, 125),
  AssetData("VVAR3", "Stock", 1, 50),
  AssetData("CDB 140% CDI", "CDB", 1, 102),
  AssetData("CDB 120% CDI", "CDB", 1, 102),
  AssetData("CDB 100% CDI", "CDB", 1, 200),
  AssetData("Ether", "Crypto", 1, 600),
  AssetData("XRP", "Crypto", 1, 150),
  AssetData("Bitcoin", "Crypto", 1, 120),
  AssetData("Cadarno", "Crypto", 1, 100),
  AssetData("Dogcoin", "Crypto", 1, 90),
]);

const crypto = AssetGroup('Crypto', 'red', [
  AssetData("Bitcoin", "Crypto", 1, 180412),
  AssetData("Ether", "Crypto", 1, 48121),
  AssetData("XRP", "Crypto", 1, 403),
]);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = [
      localStock,
      crypto,
    ];

    return DetailsPage(data[0].name, data[0].data);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Balancer"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ...data.map((d) {
              return OpenContainer<bool>(
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (context, _) {
                  return DetailsPage(d.name, d.data);
                },
                onClosed: (_) {},
                closedColor: Colors.transparent,
                openColor: Colors.transparent,
                closedBuilder: (context, action) {
                  print("data is ${d.data}");
                  return HomeScreenCard(d.name, d.data, d.colorTheme, action);
                },
              );
            }),
            // HomeScreenCard("Local Stocks", "", () {}),
            // HomeScreenCard("Global Stocks", "", () {}),
            // HomeScreenCard("Crypto", "", () {}),
          ],
        ),
      ),
    );
  }
}

class AssetGroup {
  final String name;
  final String colorTheme;
  final List<AssetData> data;

  const AssetGroup(this.name, this.colorTheme, this.data);
}

class AssetKind {
  final String kind;
  final String color;
  final String id;

  const AssetKind(this.id, this.kind, this.color);
}

class AssetData {
  final String name;
  final String kind;
  final double quantity;
  final double price;

  const AssetData(this.name, this.kind, this.quantity, this.price);
}

class HomeScreenCard extends StatelessWidget {
  final String title;
  final String colorTheme;
  final List<AssetData> data;
  final VoidCallback onClicked;

  const HomeScreenCard(this.title, this.data, this.colorTheme, this.onClicked);

  @override
  Widget build(BuildContext context) {
    final List<AssetData> sortedData = [...data]..sort((a, b) {
        return (b.price * b.quantity).compareTo((a.price * a.quantity));
      });

    final Map<String, List<AssetData>> groupedData = groupBy(sortedData);

    final colors = getColorByQuantile(groupedData, sortedData);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onClicked,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0x14c6ffdd), Color(0x14fbd786), Color(0x14f7797d)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 25,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HorizontalProgressBar(
                  data: sortedData,
                  colors: colors,
                  isProportional: false,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ClipRect(
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: spaceRow(
                      20,
                      [
                        for (int i = 0; i < sortedData.length; i++)
                          MiniName(sortedData[i].name, colors[sortedData[i]] ?? Colors.red)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<double> retrieveSpacedList(List<AssetData> data, double maxSize) {
  // data.length == 2 => 2
  // data.length == 3 => 4
  // therefore, (data.length - 1) * 2
  final double maxWH = maxSize - (data.length - 1) * 2;

  final double totalValue = data
      .map((d) => d.price * d.quantity)
      .fold(0.0, (previous, current) => previous + current);

  return data.map((d) => maxWH * (d.price * d.quantity) / totalValue).toList();
}

class HorizontalProgressBar extends StatelessWidget {
  final List<AssetData> data;
  final Map<AssetData, Color> colors;

  final bool isProportional;

  const HorizontalProgressBar({
    required this.data,
    required this.colors,
    required this.isProportional,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<double> spacedList =
            retrieveSpacedList(data, constraints.maxWidth);

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: spaceRow(2, [
            for (int i = 0; i < data.length; i++)
              Container(
                width: spacedList[i],
                height: double.infinity,
                color: colors[data[i]],
              ),
          ]),
        );
      },
    );
  }
}

class MiniName extends StatelessWidget {
  final String title;
  final Color color;

  const MiniName(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Map<int, Color> getColor(String colorType) {
  return tailwindColors[colorType]!;
}
