import 'package:bluescooters/payment/PaymentsRepository.dart';
import 'package:bluescooters/screens/chat_screen.dart';
import 'package:bluescooters/screens/location.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/widgets/roundedButton.dart';
import 'package:bluescooters/constants.dart';
import 'package:bluescooters/db/SquareUserData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '2';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  String pass = '';
  String errorMessage = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Firebase.initializeApp();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image(image: AssetImage('images/logo.jpg'),)
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                style: const TextStyle(color: Colors.black),
                decoration: KUserInputDecoration.copyWith(hintText:'Enter your email' ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  pass = value;
                  //Do something with the user input.
                },
                style: const TextStyle(color: Colors.black),
                decoration:KUserInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 12.0,
              ),
              (errorMessage.isNotEmpty ?
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              )
                  : Container(width: 0,height: 10,)),
              SizedBox(height: 10),
              RoundedButton(callback: () async {
                setState(() {
                  showSpinner = true;
                  errorMessage = '';
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: pass);
                  if(newUser == null) {
                    throw Exception("Email address already registered.");
                  }

                  var idInSquare = await PaymentsRepository.createSquareUser(email);
                  await SquareUserData.postToCollection('users', email, {'square_id': idInSquare});
                  print('Document posted successfully.');

                  Navigator.pushNamed(context, MapSample.id);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    setState(() {
                      errorMessage = 'The password provided is too weak.';
                    });
                  } else if (e.code == 'email-already-in-use') {
                    setState(() {
                      errorMessage = 'The account already exists for that email.';
                    });
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                }
                setState(() {
                  showSpinner = false;
                });
                // debugPrint(email);
                // debugPrint(pass);
              }, color: Colors.blueAccent, text: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
