import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/widgets/scooter_card.dart';
import 'package:bluescooters/db/get_scooters.dart';


//dragable menu of scooters at bottom
class DragWidget extends StatelessWidget {
  String location = "";
  DragWidget({required this.location});

  final storage = FirebaseStorage.instance;
  final List<List<String>> scooterInfos = [["Amos","El Trinidad's scooter","images/scooter_prev_ui.png"],["Ismail","El Toto Ismail","images/scooter_prev_ui.png"]];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2, // Initial percentage of the screen height
      minChildSize: 0.2, // Minimum percentage of the screen height
      maxChildSize: 0.8, // Maximum percentage of the screen height
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(0.0, -1.0),
              ),
            ],
          ),
          child:
          SingleChildScrollView(
            controller: scrollController,
            physics: ClampingScrollPhysics(),
            child:

            Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 12.8, bottom: 21),
                  child: Container(
                    height: 7.46,
                    width: 65.29,
                    decoration: BoxDecoration(
                      color: Color(0xFFCFCCD4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                // Add your content here
                // Example:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Scooters at ${location}", style: TextStyle(color:Colors.black, fontSize: 17),),
                    Text("${scooterInfos.length} scooters", style: TextStyle(color:Color(0xFFCFCCD4), fontSize: 15),),

                  ],
                ),
                // ...scooterInfos.map((args) => scooterCard(owner: args[0], name: args[1], image: args[2])),
                // Expanded(child: station_scooters()),
                // station_scooters(),
                Container(
                  width: 10000,
                  height: 10000,
                  child: station_scooters(),
                )
                // ... more scooterInfos
              ],
            ),
          ),
        );
      },
    );
  }
}

