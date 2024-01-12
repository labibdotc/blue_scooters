import 'package:flutter/material.dart';
import 'package:bluescooters/screens/TripEnded.dart';
import 'dart:async';

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
        child:MaterialApp(
          home: TimerScreen(),
        )
    );
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

    return '$hours:${_formatTwoDigits(minutes)}:${_formatTwoDigits(seconds)}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Timer: ${_formatTime(_seconds)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                _navigateToHomeScreenWithPopup(context);
              },
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
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}