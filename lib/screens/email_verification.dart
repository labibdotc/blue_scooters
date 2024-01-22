import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bluescooters/screens/location.dart';
import 'package:bluescooters/db/Users.dart';
import 'package:bluescooters/payment/PaymentsRepository.dart';



class WaitingScreen extends StatefulWidget {
  static String id = "WaitingScreen";
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void checkAuthenticationStatus() async {
    User? user = _auth.currentUser;
    print("here");
    if (user != null && user.emailVerified) {
      // User is authenticated and email is verified
      Navigator.pushReplacementNamed(context, MapSample.id);
    }
  }
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus(); // Call this method when the widget is created

    // Start listening for changes in user authentication state
    _auth.authStateChanges().listen((User? user) async {
      print(user);
      if (user != null) {
        print(user.emailVerified);
      }
      if (user != null && user.emailVerified) {
        // User is authenticated and email is verified
        // Navigate to the next screen or perform other actions
        var email = _auth.currentUser!.email!;
        var idInSquare = await PaymentsRepository.createSquareUser(email);
        await SquareUserData.postToCollection('users', email, {'square_id': idInSquare});
        print('Document posted successfully.');
        Navigator.pushReplacementNamed(context, MapSample.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting for verification. Check your email!'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}