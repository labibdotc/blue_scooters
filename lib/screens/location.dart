import 'package:bluescooters/db/Users.dart';
import 'package:bluescooters/payment/PaymentsRepository.dart';
import 'package:bluescooters/widgets/dragableWidget.dart';
import 'package:bluescooters/payment/PaymentsRepository.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bluescooters/db/StationScooters.dart';
import 'package:firebase_auth/firebase_auth.dart';

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapSample extends StatefulWidget {
  static const String id = "MapSample";

  // FIXME: You need to pass in your access token via the command line argument
  // --dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE
  // It is also possible to pass it in while running the app via an IDE by
  // passing the same args there.
  //
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: MapSample.ACCESS_TOKEN.isEmpty ||
              MapSample.ACCESS_TOKEN.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : AnimateCamera(),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

//Widget that shows map, handles map controller and manage states of locations
class AnimateCameraPage extends StatelessWidget {
  final Widget leading = const Icon(Icons.map);
  final String title = ' Camera control, animated';
  @override
  Widget build(BuildContext context) {
    return const AnimateCamera();
  }
}

class AnimateCamera extends StatefulWidget {
  const AnimateCamera();
  @override
  State createState() => AnimateCameraState();
}

class AnimateCameraState extends State<AnimateCamera> {
  late MapboxMapController mapController;
  late GlobalKey<DragWidgetState> childKey;
  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';
    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
      ..r = 255
      ..g = 0
      ..b = 0;
    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
      ..r = 36
      ..g = 152
      ..b = 141;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
      ..r = 114
      ..g = 114
      ..b = 114;

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  @override
  void initState() {
    super.initState();
    childKey = GlobalKey<DragWidgetState>();
    if (Platform.isIOS) {
      _setIOSCardEntryTheme();
    }
    isCardEntered();
  }
  Future<void> isCardEntered() async {
    String? user_id;
    final user = FirebaseAuth.instance.currentUser!;
    if (user == null) {
      throw Exception("user is nil!");
    } else {
      user_id = user?.email;
    }
    userInSquare = await SquareUserData.getUserSquareID(user_id);
    try {
      await PaymentsRepository.getCardDetailsFromSquare(userInSquare);
    } catch (e) {
      setState(() {
        cardEntered = false;
      });

    }
  }

  String scooter_station = "Campus Center";
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  List<Object>? _featureQueryFilter;
  String userInSquare = '';
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  Color locationColor = Colors.black;

  Widget _myLocationTrackingModeCycler() {
    final MyLocationTrackingMode nextType = MyLocationTrackingMode.Tracking;
    // values[
    //     (_myLocationTrackingMode.index + 1) %
    //         MyLocationTrackingMode.values.length];
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: IconButton(
          icon: const Icon(Icons.location_on),
          iconSize: 22,
          splashColor: Colors.white,
          color: locationColor,
          tooltip: 'Locate me',
          onPressed: () {
            setState(() {
              locationColor = Colors.blue;
              _myLocationTrackingMode = nextType;
            });
          },
        ),
      ),
    );
  }

  void updateStationInChild(String newStation) {
    childKey.currentState?.updateStationInChild(newStation);
  }

  /**
   * Callback when card entry is cancelled and UI is closed
   */
  void _onCancelCardEntryFlow() async {
    // Handle the cancel callback
    print("cancel called");
    await isCardEntered();
  }

  /**
   * Callback when the card entry is closed after call 'completeCardEntry'
   */
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
    print("card entry complete");
  }

  /**
   * Callback when successfully get the card nonce details for processig
   * card entry is still open and waiting for processing card nonce details
   */
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
      String? user_id;
      final user = FirebaseAuth.instance.currentUser!;
      if (user == null) {
        throw Exception("user is nil!");
      } else {
        user_id = user?.email;
      }
      userInSquare = await SquareUserData.getUserSquareID(user_id);
      await PaymentsRepository.loadNonce(result.nonce, userInSquare);
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);

    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      print("there is a problem");
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
    await isCardEntered();
  }

  Future<void> _initSquarePayment() async {
    print("initializing Square payment");
    await InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-O4lvBauO1sZhztTGGrAqMw');
  }

  /**
   * An event listener to start card entry flow
   */
  Future<void> _onStartCardEntryFlow() async {
    print("onStart Card Entry Flow");
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  _payment() async {
    await _initSquarePayment();
    await _onStartCardEntryFlow();
  }
  bool cardEntered = true;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      MapboxMap(
        // styleString:"https://studio.mapbox.com/tilesets/labib1.clr2aydjt1di91nnmwe9ugjvn-8ygfv", //"labib1.clr2aydjt1di91nnmwe9ugjvn-8ygfv",
        accessToken: MapSample.ACCESS_TOKEN,
        onMapCreated: _onMapCreated,
        onMapClick: (point, coordinates) async {
          List features = await mapController.queryRenderedFeatures(
              point,
              ['tufts-campus2'],
              _featureQueryFilter); // replace with your layer name
          if (features.length > 0) {
            print(features.first["properties"]["title"]);
            updateStationInChild(features.first["properties"]["title"]);
          }
        },
        myLocationTrackingMode: _myLocationTrackingMode,
        myLocationRenderMode: MyLocationRenderMode.GPS,

        styleString: "mapbox://styles/labib1/clr3pkpnf00x201nt8oeo7a55",

        // cameraTargetBounds: CameraTargetBounds(LatLngBounds(southwest: const LatLng(42, -71), northeast: const LatLng(42.4, -71.1))),
        initialCameraPosition: const CameraPosition(
          target: LatLng(42.409, -71.12363),
          zoom: 14.0,
        ),
        onCameraTrackingDismissed: () {
          // Handle camera movement here
          setState(() {
            locationColor = Colors.black;
          });
          setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        }, //start map from tufts where it was founded
      ),
      Positioned(
        top: 100,
        left: 20,
        child: RawMaterialButton(
          child: Icon(Icons.credit_card),
          fillColor: !cardEntered ? Colors.white : Colors.grey, // You can change this to any icon you want
          onPressed: !cardEntered ? () async {
            // Add your custom logic here
            setState(() {
              cardEntered = true;
            });
            _payment();
            //check if there is a card now in square if not
          } : null,
          elevation: 5,
          padding: EdgeInsets.all(15.0),
          // tooltip: 'This is a tooltip for guidance',
          shape: CircleBorder(),
        ),
      ),
      !cardEntered ? Positioned(
          top: 110,
          left: 110,
          child: Opacity(
            opacity: 0.5,
            child: Container( height: 30, width: 130,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text("Enter your card"))
            ),
          )) : Container(),
      Positioned(
          bottom: 200, right: 20, child: _myLocationTrackingModeCycler()),
      DragWidget(key: childKey),
    ]);
  }
}
