import 'package:bluescooters/screens/login_screen.dart';
import 'package:bluescooters/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bluescooters/widgets/roundedButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = '1';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  var controller;
  var animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   debugPrint("Firebase launch completed");
    //   setState(() {});
    // });
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation =
        ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed) controller.reverse(from: 1.0);
    //   else {
    //     controller.forward();
    //   }
    // });
    controller.addListener(() {
      setState(() {});
      // print(animation.value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.jpg'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Blue Scooters',
                        textStyle: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                        speed: const Duration(milliseconds: 200))
                  ],
                  repeatForever: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(callback: () {Navigator.pushNamed(context, LoginScreen.id);}, color: Colors.lightBlueAccent, text: 'Log In'),
            RoundedButton(callback: () {Navigator.pushNamed(context, RegistrationScreen.id);}, color: Colors.blueAccent, text: 'Register'),
          ],
        ),
      ),
    );
  }
}
