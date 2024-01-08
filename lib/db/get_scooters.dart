import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluescooters/widgets/scooter_card.dart';

class station_scooters extends StatelessWidget {
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
        var data = documentSnapshot.data();
        var name = data!['name'] ?? 'No Name';
        var owner = data!['owner'] ?? 'No Owner';
        var imageUrl = data!['image_url'] ?? 'No Image URL';

        // Return a Map containing the extracted fields
        return {'name': name, 'owner': owner, 'image_url': imageUrl};
      } else {
        print('Document does not exist');
        return {'name': 'No Name', 'owner': 'No Owner', 'image_url': 'No Image URL'};
      }
    } catch (error) {
      print('Error getting document: $error');
      return {'name': 'No Name', 'owner': 'No Owner', 'image_url': 'No Image URL'};
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stations').doc("Campus_Center").collection("scooters").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          // print("line 20");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: Colors.blue);
          }
          // print("line 24");

          // If data is available, build the list of users
          final users = snapshot.data!.docs;
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                // Access individual user data
                var scooter_data = users[index].data() as Map<String, dynamic>;
                var scooter = scooter_data['scooter_id'] ?? 'No Name';
                // print("line 34");
                // getSpecificDocument(scooter).then((scooter_info) {
                //   print(scooter_info);
                // });

                return FutureBuilder(
                    future: getSpecificDocument(scooter),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        var scooter_info = snapshot.data as Map<String,dynamic>;
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