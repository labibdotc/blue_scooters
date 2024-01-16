import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluescooters/widgets/scooter_card.dart';

class station_scooters extends StatelessWidget {
  final Function(int) callback;
  final String formatted_station_name;
  static String formatStationNameInDb(String station) {
    return station.replaceAll(' ', '_');
  }
  station_scooters(
      {required this.callback, required this.formatted_station_name});
  Future<void> leaveStation(String scooter_id) async {
    // Use the 'scooters' collection and the provided documentId
    var originalDocumentReference = FirebaseFirestore.instance.collection("stations").doc(formatted_station_name).collection("scooters").doc(scooter_id);

    // Retrieve the document
    var documentSnapshot = await originalDocumentReference.get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Delete the document from the original collection
      await originalDocumentReference.delete();

      // Access the data from the document
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;


      // Use another collection reference (e.g., 'archived_scooters') to store a copy
      var inTripScootersReference = FirebaseFirestore.instance.collection('inTrip');


      //Can produce data rac
      await inTripScootersReference.doc(scooter_id).set(data);


      print('scooter released from station and is now in trip.');
    } else {
      throw Exception("Chosen scooter is no more available");
    }
  }
  static void return_to_station(String station_name, String scooter_id) async {
    // Use the 'scooters' collection and the provided documentId
    var originalDocumentReference = FirebaseFirestore.instance.collection('inTrip').doc(scooter_id);

    // Retrieve the document
    var documentSnapshot = await originalDocumentReference.get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Delete the document from the original collection
      await originalDocumentReference.delete();
      // Access the data from the document
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      // Use another collection reference (e.g., 'archived_scooters') to store a copy
      var newStationScootersReference = FirebaseFirestore.instance.collection("stations").doc(station_name).collection("scooters");


      //Can produce data rac
      await newStationScootersReference.doc(scooter_id).set(data);



      print('scooter released return to => ' + station_name);
    } else {
      // Document doesn't exist
      print('Document does not exist');
    }
    await Future.delayed(Duration(seconds: 3), () {
      print("left: "+ station_name);
    });

  }
  static String id = "10";
  Future<Map<String, dynamic>> getSpecificDocument(String documentId) async {
    try {
      // Use the 'scooters' collection and the provided documentId
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('scooters')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        // Document exists, extract and return the desired fields
        //TODEBUG: add ?? "No image";
        var data = documentSnapshot.data();
        var name = data!['name'];
        var owner = data!['owner'];
        var imageUrl = data!['image_url'];
        // Return a Map containing the extracted fields
        return {'name': name, 'owner': owner, 'image_url': imageUrl};
      } else {
        print('Document does not exist');
        return {'name': "", 'owner': "", 'image_url': ""};
      }
    } catch (error) {
      print('Error getting document: $error');
      return {'name': "", 'owner': "", 'image_url': ""};
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stations').doc(formatted_station_name).collection("scooters").snapshots(),
        builder: (context, snapshot) {
          print(formatted_station_name);
          if (snapshot.hasError) {
            return Container(color: Colors.white,); // Return nothing
          }
          // print("line 20");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(color: Colors.white); // Return nothing
          }
          // print("line 24");

          // If data is available, build the list of users
          final scooters = snapshot.data!.docs;
          // print(scooters.length);
          // callback(scooters.length); //TODO: to make the scooter length change for display
          return ListView.builder(
              padding: EdgeInsets.zero, // Set padding to zero to remove it completely
              itemCount:  scooters.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // Access individual user data
                var scooter_data = scooters[index].data() as Map<String, dynamic>;
                var scooter = scooter_data['scooter_id'] ?? 'No Name';
                // print("line 34");
                // getSpecificDocument(scooter).then((scooter_info) {
                //   print(scooter_info);
                // });


                return FutureBuilder(
                    future: getSpecificDocument(scooter),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: Colors.white); // Return nothing
                      } else if (snapshot.hasError) {
                        return Container(color: Colors.white); // Return nothing
                      } else {
                        var scooter_info = snapshot.data as Map<String,dynamic>;
                        if (scooter_info["owner"] == "" || scooter_info["name"] == "" || scooter_info["image_url"] == "") {
                          return Container(color: Colors.white);
                        }
                        return stationCard(owner: scooter_info["owner"], name: scooter_info["name"], image: scooter_info["image_url"], leaveStation: leaveStation);


                      }
                    }


                );

              }
          );
        },

    );
  }
}