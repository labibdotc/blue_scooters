import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/widgets/scooter_card.dart';
import 'package:bluescooters/db/get_scooters.dart';
class DragWidget extends StatefulWidget {
  DragWidget({Key? key}) : super(key: key);

  @override
  State<DragWidget> createState() => DragWidgetState();
}

class DragWidgetState extends State<DragWidget> {
  String location = "campus center";
  final storage = FirebaseStorage.instance;
  int scooter_count = 0;

  @override
  void initState() {
    super.initState();
  }
  void updateStationInChild(String newStation) {
    setState(() {
      location = newStation;
    });
  }
  void newScooterCallback(int scooterCount) {
    setState(() {
      scooter_count = scooterCount;
    });
  }
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
            physics: const ClampingScrollPhysics(),
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
                    // Text("${scooter_count} scooters", style: TextStyle(color:Color(0xFFCFCCD4), fontSize: 15),), //TODO: uncomment to add the count of scooters

                  ],
                ),
                // ...scooterInfos.map((args) => scooterCard(owner: args[0], name: args[1], image: args[2])),

                Container(
                  //TODO: change these hardcoded values
                  width: 10000,
                  height: 100, //TODO: potential overflow, but for now restricts the bouncing when dragged
                  padding: EdgeInsets.zero,
                  child: station_scooters(callback: newScooterCallback, station_name: location.replaceAll(' ', '_'),),
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