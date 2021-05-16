import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/row_column_spacer.dart';
import '../util/tailwind_colors.dart';
import 'users_input_dialog.dart';

class WhenEmptyCard extends StatelessWidget {
  const WhenEmptyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
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
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
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
}

class GroupsScreen extends StatelessWidget {
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
      // TODO uncomment. This was changed because now we listen to groups from individual users.
      // body: StreamBuilder<FullDataExtended2>(
      //     stream: BlocProvider.of<DataBloc>(context).db.watchGroups(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         final listData = snapshot.data!.itemsList;
      //
      //         if (listData.isEmpty) {
      //           return WhenEmptyCard(
      //             title: AppLocalizations.of(context)!.mainEmptyTitle,
      //             subtitle: AppLocalizations.of(context)!.mainEmptySubtitle,
      //             icon: Icons.account_balance,
      //           );
      //         }
      //
      //         return Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: ListView.builder(
      //             itemCount: listData.length,
      //             itemBuilder: (context, index) {
      //               final data = listData[index];
      //
      //               return OpenContainer<bool>(
      //                 transitionType: ContainerTransitionType.fadeThrough,
      //                 openBuilder: (context, _) {
      //                   return Text("Expanded");
      //                   // return DetailsPage(data.key.id);
      //                 },
      //                 onClosed: (_) {},
      //                 closedColor: Colors.transparent,
      //                 openColor: Colors.transparent,
      //                 closedBuilder: (context, action) {
      //                   print("data is ${data}");
      //
      //                   // return Text(data.item?.name ?? "Empty");
      //                   if (listData.isEmpty) {
      //                     // return HomeScreenEmptyCard(data.key.name, action, () {
      //                     //   showAddEditDialog(context, data.key);
      //                     // });
      //                   } else {
      //                     return Text("NOT NULL");
      //                     // return HomeScreenCard(
      //                     //   data.key.name,
      //                     //   data.value,
      //                     //   action,
      //                     // );
      //                   }
      //                 },
      //               );
      //             },
      //           ),
      //         );
      //       } else if (snapshot.hasError) {
      //         return Text("Error is ${snapshot.error}");
      //       } else {
      //         return Center(child: CircularProgressIndicator());
      //       }
      //     }),
    );
  }

  void showAddEditDialog(BuildContext context, [User? user]) {
    showDialog<dynamic>(
      context: context,
      builder: (_) => HomeInputDialog(
        initialValue: user?.name,
        onSavePressed: (text) {
          if (user != null) {
            // Update the existing Group with text.
            BlocProvider.of<DataBloc>(context)
                .db
                .editUser(user.copyWith(name: text));
          } else {
            // Create a new Group
            BlocProvider.of<DataBloc>(context).db.createUser(text);
          }
        },
      ),
    );
  }
}

// class HomeScreenCard extends StatelessWidget {
//   final FullDataExtended data;
//   final VoidCallback onClicked;
//
//   const HomeScreenCard(this.data, this.onClicked);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: onClicked,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [Color(0x14c6ffdd), Color(0x14fbd786), Color(0x14f7797d)],
//             ),
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'title',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 width: double.infinity,
//                 height: 25,
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 // child: HorizontalProgressBar(
//                 //   data: data,
//                 //   isProportional: false,
//                 // ),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 width: double.infinity,
//                 child: ClipRect(
//                   clipBehavior: Clip.antiAlias,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: spaceRow(
//                       20,
//                       [
//                         for (int i = 0; i < data.fullData.length; i++)
//                           MiniName(
//                             data.fullData[i].item.name,
//                             data.colors[i] ?? Colors.red,
//                           )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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

// TODO uncomment this.
// class HorizontalProgressBar extends StatelessWidget {
//   final FullDataExtended data;
//
//   final bool isProportional;
//
//   const HorizontalProgressBar({
//     required this.data,
//     required this.isProportional,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final List<double> spacedList =
//             retrieveSpacedList(data.fullData, constraints.maxWidth);
//
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: spaceRow(2, [
//             for (int i = 0; i < data.colors.length; i++)
//               Container(
//                 width: spacedList[i],
//                 height: double.infinity,
//                 color: data.colors[i],
//               ),
//           ]),
//         );
//       },
//     );
//   }
// }

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
