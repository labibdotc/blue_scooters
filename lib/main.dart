import 'package:bluescooters/screens/camera.dart';
import 'package:bluescooters/screens/location.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/screens/welcome_screen.dart';
import 'package:bluescooters/screens/login_screen.dart';
import 'package:bluescooters/screens/registration_screen.dart';
import 'package:bluescooters/screens/chat_screen.dart';
import 'package:bluescooters/screens/product_description.dart';
import 'package:bluescooters/screens/stream_experiment.dart';//TODO: remove in production
import 'package:bluescooters/screens/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart';
import 'firebase_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'camera_common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //name: "co.labib.bluescooters"
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // auth = FirebaseAuth.instanceFor(app: app);
  // await FirebaseFirestore.instance.collection("stations").doc("Campus_Center").collection("scooters").get().then((event) {
  //   for (var doc in event.docs) {
  //     print("${doc.id} => ${doc.data()}");
  //   }
  // }).catchError((error) {
  //   print('Error: $error');
  // })
  // ;

  Cameras = await availableCameras();
  runApp(FlashChat());

}
void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}
class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: MapSample.id,
      routes:{
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ProductDescription.id: (context) => ProductDescription(),
        CameraApp.id: (context) => CameraApp(),
        MyApp.id: (context) => MyApp(),
        MapSample.id: (context) => MapSample(),
        ChatToDemoStream.id: (context) => ChatToDemoStream()
      }
    );
  }
}
