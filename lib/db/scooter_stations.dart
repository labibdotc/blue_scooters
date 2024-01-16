import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

class scooterStations {
  static Future<List<String>> getPermittedStations(String scooter_id) async {
    try {
      // Get the reference to the document
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance
          .collection('scooterStations')
          .doc(scooter_id)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        // Access the 'stations' field and convert it to a List<String>
        List<String> stations = List<String>.from(data['stations'] ?? []);

        return stations;
      } else {
        // Document doesn't exist
        print('Document does not exist');
        return [];
      }
    } catch (e) {
      print('Error getting stations list: $e');
      return [];
    }
  }
}