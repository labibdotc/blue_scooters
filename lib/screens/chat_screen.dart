import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluescooters/db/get_scooters.dart';


class MyApp extends StatelessWidget {
  static String id = "10";
  @override
  Widget build(BuildContext context) {
    return station_scooters();
  }
}