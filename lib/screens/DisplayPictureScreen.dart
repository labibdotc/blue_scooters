import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bluescooters/db/TripPictures.dart';
import 'package:bluescooters/db/TripInfo.dart';
import 'package:bluescooters/screens/InTrip.dart';
import 'package:bluescooters/db/TripPictures.dart';
import 'package:bluescooters/db/TripInfo.dart';
import 'package:bluescooters/screens/camera.dart';
import 'package:bluescooters/db/StationScooters.dart';
import 'package:bluescooters/screens/location.dart';
import 'package:bluescooters/db/Users.dart';
import 'package:bluescooters/db/ScooterTrips.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String scooter_id;
  final int scooter_start_price;
  final Map<String,dynamic>? returnData;



  DisplayPictureScreen({required this.imagePath, required this.scooter_id, required this.scooter_start_price,  this.returnData});

  static String generateRandomTripId() {
    int len = 20;
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  Future<void> actionsAfterScooterReturnPicture(BuildContext context,String returnStation, String tripId, String imagePath, DateTime endTime, int scooter_end_price, int rounded_up_mins_duration) async {

    // Handle the tap for the second button
    print("Accepted Image");
    //Save picture
    TripPictures.uploadImageToFirebase(imagePath, 'trips/${tripId}/end'); //TODO: decide if we should make the user wait until we make sure the picture is in the cloud
    await TripInfo.uploadEndInfoToFirebase(tripId, "trips/${tripId}/end", endTime, scooter_end_price, rounded_up_mins_duration );
    // Navigate back to the home screen
    Navigator.popUntil(
        context, (route) => route.settings.name == MapSample.id);

    station_scooters.return_to_station(station_scooters.formatStationNameInDb(returnStation), scooter_id);

  }

  Future<void> actionsAfterScooterCheckoutPicture(BuildContext context, String imagePath, DateTime dateTime, int scooter_start_price) async {
    // Handle the tap for the second button
    print("Accepted Image");
    //Step 1: generate a unique trip id of len 20
    String tripId = generateRandomTripId();
    print("tripId is " +tripId);
    //Save picture
    TripPictures.uploadImageToFirebase(imagePath, 'trips/${tripId}/start'); //TODO: decide if we should make the user wait until we make sure the picture is in the cloud

    await TripInfo.uploadStartInfoToFirebase(tripId, 'trips/${tripId}/start', dateTime,scooter_start_price);

    var email = FirebaseAuth.instance.currentUser!.email!;
    await UserTripData.addTripIdToUser(email, tripId);
    await ScooterTrips.addTripIdToScooter(scooter_id, tripId);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InTrip(scooter_id: scooter_id, start_time: dateTime, trip_id: tripId,dollarsRatePer30Mins: scooter_start_price/100,)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Text("Ready to submit?", style: TextStyle(color: Colors.black, fontSize: 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularButton(
                        color: Colors.red,
                        onPressed: () {
                        // Handle the tap for the first button
                          print("retake image");
                          Navigator.pop(context);
                        },
                        icon: Icons.restart_alt,
                        ),
                        CircularButton(
                        color: Colors.green,
                        onPressed: () async {
                          if (returnData == null) {
                            actionsAfterScooterCheckoutPicture(context, imagePath,DateTime.now(), scooter_start_price);//TODO: scooter_start_price stores end price in case of return
                          } else {
                            var trip_id = returnData!['trip_id'];
                            var start_time = returnData!['start_time'];
                            var returnStation = returnData!['return_station'];
                            DateTime endTime = DateTime.now();
                            print("Trip ended at"+ endTime.toString() +"and started at"+ start_time.toString());
                            Duration difference = endTime.difference(start_time);

                            // Access individual components of the duration
                            var minuteDurationRoundedUp = (difference.inSeconds / 60).ceil();
                            //calculate difference in time
                            print("which is ${minuteDurationRoundedUp} minutes");
                            var paymentAmount =scooter_start_price;
                            //TODO: charge the extra, if any
                            if (minuteDurationRoundedUp > 30) {
                              var overTimeMinutes = minuteDurationRoundedUp - 30;
                              var extraPeriods = (overTimeMinutes/30).ceil();
                              print("TODO: Charge the card ${extraPeriods} times more");
                              paymentAmount += extraPeriods*paymentAmount;
                            }
                            var rounded_up_mins_duration = minuteDurationRoundedUp;
                            actionsAfterScooterReturnPicture(context,returnStation, trip_id, imagePath, endTime, paymentAmount, rounded_up_mins_duration);
                          }
                          // onPictureSubmission(context, imagePath,DateTime.now(), scooter_start_price);
                          } ,
                        icon: Icons.check,
                        ),
                      ],
                  ),
              ],
            ),
          ),

        ],
      ),

    );
  }
}
class CircularButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final IconData icon;

  CircularButton({required this.color, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}