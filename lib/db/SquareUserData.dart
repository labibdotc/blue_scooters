import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class SquareUserData {
  static Future<void> postToCollection(String collectionName, String documentId, Map<String, dynamic> data) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);

    // Check if the document already exists
    DocumentSnapshot documentSnapshot = await collection.doc(documentId).get();
    if (documentSnapshot.exists) {
      throw Exception("Square user already exists. Cannot overwrite.");
    }

    // If the document doesn't exist, add it
    await collection.doc(documentId).set(data);
  }
  static Future<String> getUserSquareID(String? userId) async {

      // Get the user document from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // Check if the document exists and contains an email field
      if (userSnapshot.exists && userSnapshot.data() != null) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        String square_user_id = userData['square_id'];
        return square_user_id;
      }
      throw Exception("User's account can't hold a card. Please contact developer");
  }
}