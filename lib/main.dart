import 'package:bluescooters/screens/camera.dart';
import 'package:bluescooters/screens/location.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/screens/welcome_screen.dart';
import 'package:bluescooters/screens/login_screen.dart';
import 'package:bluescooters/screens/registration_screen.dart';
import 'package:bluescooters/screens/product_description.dart';
import 'package:bluescooters/screens/payment.dart';
import 'package:bluescooters/screens/InTrip.dart';
import 'package:bluescooters/screens/stream_experiment.dart';//TODO: remove in production
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'firebase_options.dart';
import 'camera_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'env.dart';





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
  await loadDotenv();
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
        onGenerateRoute: (settings) {
          if (settings.name == ProductDescription.id) {
            // Extract arguments from settings
            Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;

            // Check if the required parameter is present
            if (arguments.containsKey('scooter_id') && arguments.containsKey('scooter_owner')) {
              // Return MaterialPageRoute with the ProductDescription widget
              return MaterialPageRoute(
                builder: (context) => ProductDescription(
                  scooter_id: arguments['scooter_id'],
                  scooter_owner: arguments['scooter_owner'],
                ),
              );
            }
          }

          if (settings.name == Payment.id) {
            // Extract arguments from settings
            Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;

            // Check if the required parameter is present
            if (arguments.containsKey('owner_id') && arguments.containsKey('payment_amount') && arguments.containsKey('rider_id')) {
              // Return MaterialPageRoute with the ProductDescription widget
              return MaterialPageRoute(
                builder: (context) => Payment(
                  payment_amount: arguments['payment_amount'],
                  owner_id: arguments['owner_id'],
                  rider_id: arguments['rider_id'],
                ),
              );
            }
          }

          // Handle other routes or return null
          // For example, return a MaterialPageRoute for a default page
          return MaterialPageRoute(builder: (context) => Container(color: Colors.white));
        },
      initialRoute: MapSample.id,
      routes:{
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        CameraApp.id: (context) => CameraApp(),
        // MyApp.id: (context) => MyApp(),
        MapSample.id: (context) => MapSample(),
        ChatToDemoStream.id: (context) => ChatToDemoStream(),
        InTrip.id: (context) => InTrip()
      }
    );
  }
}
