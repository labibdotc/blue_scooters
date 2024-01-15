import 'package:flutter/material.dart';
import 'package:bluescooters/screens/location.dart';
import 'dart:async';
import 'package:bluescooters/widgets/station_card.dart';

class InTrip extends StatelessWidget {
  static const String id = "InTrip";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Custom logic codes
          // Return true to allow back navigation, false to prevent it
          return false;
        },
        child: MaterialApp(
          home: TimerScreen(),
        ));
  }
}

class TimerScreen extends StatefulWidget {
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
            Container(
              width: 374, // Set the width of the rectangle
              height: 48, // Set the height of the rectangle
              decoration: BoxDecoration(
                color: Color(0xFFF8E8F8), // Set the color of the rectangle
                borderRadius: BorderRadius.circular(8), // Set the corner radius
              ),
              child: Center(
                child: Text(
                  'Make money out of your scooter too', //TODO: make this pumpy for better interactivity and to get more clicks
                  style: TextStyle(
                      color: Color(0xFF6938D3), fontWeight: FontWeight.w700),
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
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 1, // Set the thickness of the line
                ),
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
                      10,
                          (index) => stationCard(
                        name: "Carm",
                        image: "images/scooter_prev_ui.png",
                        isSelected: (index == selectedCardIndex),
                        onPressed: () => onCardPressed(index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToHomeScreenWithPopup(context);
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

  void _navigateToHomeScreenWithPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Dialog'),
          content: Text('Do you want to end the trip?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();

                // Navigate back to the home screen
                Navigator.popUntil(
                    context, (route) => route.settings.name == MapSample.id);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
