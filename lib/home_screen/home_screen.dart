import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/retrieve_spaced_list.dart';
import '../util/row_column_spacer.dart';
import '../util/tailwind_colors.dart';
import 'home_input_dialog.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wallet Balancer",
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddEditDialog(context);
        },
        icon: Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.mainFAB),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<Object>(
          stream: BlocProvider.of<DataBloc>(context).db.watchGroups(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final listData =
                  snapshot.data as Map<AssetGroup, List<ItemKindData>>;

              final listDataEntries = listData.entries.toList();

              if (listData.isEmpty) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.account_balance,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.mainEmptyTitle,
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.mainEmptySubtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: listDataEntries.length,
                  itemBuilder: (context, index) {
                    final data = listDataEntries[index];

                    return OpenContainer<bool>(
                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (context, _) {
                        return Text("EMPTY");

                        // return DetailsPage(d.name, data[0].data);
                      },
                      onClosed: (_) {},
                      closedColor: Colors.transparent,
                      openColor: Colors.transparent,
                      closedBuilder: (context, action) {
                        print("data is ${data}");

                        // return Text(data.item?.name ?? "Empty");
                        if (data.value.isEmpty) {
                          return HomeScreenEmptyCard(data.key.name, action, () {
                            showAddEditDialog(context, data.key);
                          });
                        } else {
                          return Text("NOT NULL");
                          // return HomeScreenCard(
                          //   data.key.name,
                          //   data.value,
                          //   action,
                          // );
                        }
                      },
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Error is ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void showAddEditDialog(BuildContext context, [AssetGroup? group]) {
    showDialog<dynamic>(
      context: context,
      builder: (_) => HomeInputDialog(
        initialValue: group?.name,
        onSavePressed: (text) {
          if (group != null) {
            // Update the existing Group with text.
            BlocProvider.of<DataBloc>(context)
                .db
                .editGroup(group.copyWith(name: text));
          } else {
            // Create a new Group
            BlocProvider.of<DataBloc>(context).db.createGroup(text);
          }
        },
      ),
    );
  }
}

class HomeScreenCard extends StatelessWidget {
  final FullDataExtended data;
  final VoidCallback onClicked;

  const HomeScreenCard(this.data, this.onClicked);

  @override
  Widget build(BuildContext context) {
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
                'title',
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
                  data: data,
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
                        for (int i = 0; i < data.fullData.length; i++)
                          MiniName(
                            data.fullData[i].item.name,
                            data.colors[i] ?? Colors.red,
                          )
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

class HomeScreenEmptyCard extends StatelessWidget {
  final String title;
  final VoidCallback onClicked;
  final VoidCallback onLongPress;

  const HomeScreenEmptyCard(
    this.title,
    this.onClicked,
    this.onLongPress,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onClicked,
        onLongPress: onLongPress,
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
                // child: HorizontalProgressBar(
                //   data: data,
                //   isProportional: false,
                // ),
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
                        // for (int i = 0; i < data.fullData.length; i++)
                        //   MiniName(
                        //     data.fullData[i].item.name,
                        //     data.colors[i] ?? Colors.red,
                        //   )
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

class HorizontalProgressBar extends StatelessWidget {
  final FullDataExtended data;

  final bool isProportional;

  const HorizontalProgressBar({
    required this.data,
    required this.isProportional,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<double> spacedList =
            retrieveSpacedList(data.fullData, constraints.maxWidth);

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: spaceRow(2, [
            for (int i = 0; i < data.colors.length; i++)
              Container(
                width: spacedList[i],
                height: double.infinity,
                color: data.colors[i],
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
