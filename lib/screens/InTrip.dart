import 'package:bluescooters/db/ScooterStations.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/screens/location.dart';
import 'dart:async';
import 'package:bluescooters/widgets/station_card.dart';
import 'package:bluescooters/db/StationScooters.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bluescooters/screens/camera.dart';



class InTrip extends StatelessWidget {
  static const String id = "InTrip";
  final String scooter_id;
  final String trip_id;
  final DateTime start_time;
  final double dollarsRatePer30Mins;

  InTrip({required this.scooter_id, required this.trip_id, required this.start_time, required this.dollarsRatePer30Mins});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Custom logic codes
          // Return true to allow back navigation, false to prevent it
          return false;
        },
        child: MaterialApp(
          home: TimerScreen(scooter_id: scooter_id, start_time: start_time, dollarsRatePer30Mins: dollarsRatePer30Mins, trip_id: trip_id),
        )
    );
  }
}

class TimerScreen extends StatefulWidget {
  final String scooter_id;
  final DateTime start_time;
  final double dollarsRatePer30Mins;
  final String trip_id;
  TimerScreen({required this.scooter_id, required this.start_time, required this.dollarsRatePer30Mins, required this.trip_id});
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    scooterStations.getPermittedStations(widget.scooter_id).then((list) {
      setState(() {
        returnStations = list;
      });
    });

  }

  void _updateTimer(Timer timer) {
    if (_isTimerRunning) {
      setState(() {
        _seconds++;
      });
    }
  }

  String _formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds ~/ 60) % 60;
    int seconds = timeInSeconds % 60;

    return '${_formatTwoDigits(hours)}:${_formatTwoDigits(minutes)}:${_formatTwoDigits(seconds)}';
  }

  String _formatTwoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  int selectedCardIndex = 0;

  void onCardPressed(int index) {
    setState(() {
      selectedCardIndex = index;
    });
  }
  void _launchURL() async {
    const url = 'https://docs.google.com/forms/d/e/1FAIpQLSd2HFSNsy65qfeOvIkJ-3Qqmyzr15Zleo3F6UDYpsrAdk0YHQ/viewform'; // Replace with the URL you want to open
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true);
    } else {
      _navigateToHomeScreenWithPopup(context,'Error','Talk to developers');
    }
  }
  List<String>returnStations = [];
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height:
                    statusBarHeight + 28), // Empty space to position the button
            GestureDetector(
              onTap: () {
                // Add your button's functionality here
                _launchURL();
              },
              child: Container(
                width: 374, // Set the width of the rectangle
                height: 48, // Set the height of the rectangle
                decoration: BoxDecoration(
                  color: Color(0xFFF8E8F8), // Set the color of the rectangle
                  borderRadius: BorderRadius.circular(8), // Set the corner radius
                ),
                child: Center(
                  child:
                  Text(
                    'Make money out of your scooter too', //TODO: make this pumpy for better interactivity and to get more clicks
                    style: TextStyle(
                        color: Color(0xFF6938D3), fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(height: 78), // Empty space to position the button
            Image(
                image: AssetImage('images/scooterSwoosh.png'),
                width: 123,
                height: 50),
            SizedBox(height: 28),
            Text(
              'In Trip Time',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 244, // Set the width of the rectangle
              height: 98, // Set the height of the rectangle
              decoration: BoxDecoration(
                color: Color(0xFF6938D3), // Set the color of the rectangle
                borderRadius:
                    BorderRadius.circular(40), // Set the corner radius
              ),
              child: Center(
                child: Text(
                  '${_formatTime(_seconds)}',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 33),
              child: SizedBox(
                width: 374.0, // Set the width of the SizedBox
                child: Container(),
              ),
            ),
            SizedBox(height: 9),
            Text(
              'Choose return station',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFD9D9D9),
                    width: 1.0,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      returnStations.length,
                          (index) => stationCard(
                        name: returnStations[index],
                        image: "images/scooter_prev_ui.png",
                        isSelected: (index == selectedCardIndex),
                        onPressed: () => onCardPressed(index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _navigateToHomeScreenWithPopup(context, 'End trip','Do you want to end the trip?');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF6938D3),
                minimumSize: Size(366, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Set the desired radius
                ),                // backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                //   (Set<MaterialState> states) {
                //     return const Color(0xFF6938D3);
                //   },
                // ),
              ),
              child: Text('End Trip'),
            ),
          ],
        ),
      ),
    );
  }
//
  //

  void _navigateToHomeScreenWithPopup(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
          title: Text(title, style:TextStyle(fontWeight: FontWeight.w700)),
          content: Text(content, style:TextStyle(fontWeight: FontWeight.w100)),
          actions: <Widget>[
        ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150.0,
              child: TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                  ),
                  padding: EdgeInsets.all(16.0),
                  side: BorderSide(color: Colors.blue), // Set the border color
                  primary: Colors.white, // Set the background color
                  // onPrimary: Colors.blue, // Set the color of the corners to blue
                ),
                child: Text('Cancel', style: TextStyle(color: Colors.blue)),
              ),
            ),
              SizedBox(
                width: 150.0,
              child: TextButton(
                onPressed: () {
                  //TODO: move this to server and make sure system time of server never changes.
                  //TODO: research this topic to avoid money loss.
                  // Close the dialog
                  Navigator.of(context).pop();
                  //get start time from database

                  Map<String,dynamic> returnData = {
                    'trip_id': widget.trip_id,
                    'start_time': widget.start_time,
                      'return_station': returnStations[selectedCardIndex]
                  };
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CameraApp(scooter_id: widget.scooter_id, scooter_start_price: (widget.dollarsRatePer30Mins*100).toInt(), returnData: returnData)));
                  // Navigator.popUntil(
                  //     context, (route) => route.settings.name == MapSample.id);
                  //
                  // station_scooters.return_to_station(station_scooters.formatStationNameInDb(returnStations[selectedCardIndex]), widget.scooter_id);

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                  ),
                  padding: EdgeInsets.all(16.0), // Set the border color
                  primary: Colors.blue, // Set the background color
                  onPrimary: Colors.white, // Set the color of the corners to blue
                ),
                child: Text('Yes', style: TextStyle(color:Colors.white),),
              ),
            ),
          ])],
        );
      },
    );
  }
}
