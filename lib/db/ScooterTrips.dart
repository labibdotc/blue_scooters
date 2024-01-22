import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class ScooterTrips {
  //prints should be changed to throw
  static Future<void> addTripIdToScooter(String scooter_id, String tripId) async {
    try {
      List<String> elementsToAppend = [tripId];
      await FirebaseFirestore.instance.collection('scooterTrips').doc(scooter_id).update({
        'trips': FieldValue.arrayUnion(elementsToAppend),
      });
      print('Elements appended to array field successfully');
    } catch (e) {
      print('Error appending elements to array field: $e');
    }
  }
}