import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluescooters/widgets/scooter_card.dart';

class station_scooters extends StatelessWidget {
  final Function(int) callback;
   String station_name;

  station_scooters(
      {required this.callback, required this.station_name});
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
        stream: FirebaseFirestore.instance.collection('stations').doc(station_name).collection("scooters").snapshots(),
        builder: (context, snapshot) {
          print(station_name);
          if (snapshot.hasError) {
            return Container(); // Return nothing
          }
          // print("line 20");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); // Return nothing
          }
          // print("line 24");

          // If data is available, build the list of users
          final scooters = snapshot.data!.docs;
          // print(scooters.length);
          // callback(scooters.length); //TODO: to make the scooter length change for display
          return ListView.builder(
              padding: EdgeInsets.zero, // Set padding to zero to remove it completely
              itemCount: scooters.length,
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
                        return Container(); // Return nothing
                      } else if (snapshot.hasError) {
                        return Container(); // Return nothing
                      } else {
                        var scooter_info = snapshot.data as Map<String,dynamic>;
                        if (scooter_info["owner"] == "" || scooter_info["name"] == "" || scooter_info["image_url"] == "") {
                          return Container();
                        }
                        return scooterCard(owner: scooter_info["owner"], name: scooter_info["name"], image: scooter_info["image_url"]);


                      }
                    }


                );

              }
          );
        },

    );
  }
}