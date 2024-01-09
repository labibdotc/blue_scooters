import 'package:bluescooters/widgets/dragableWidget.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bluescooters/db/get_scooters.dart';



final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapSample extends StatefulWidget {
  static const String id = "7";

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
  @override
  void initState() {
    super.initState();
    childKey = GlobalKey<DragWidgetState>();
  }
  String scooter_station = "Campus Center";
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  List<Object>? _featureQueryFilter;
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
          padding: const EdgeInsets.symmetric(
              vertical: 8, horizontal: 8),
          child: IconButton(
            icon: const Icon(Icons.location_on),
            iconSize: 22,
            splashColor: Colors.white,
            color: locationColor,
            tooltip: 'Locate me',
            onPressed: () {
              setState((){locationColor = Colors.blue;_myLocationTrackingMode = nextType;});

            },
          ),
        ),
      );



  }
  void updateStationInChild(String newStation) {
    childKey.currentState?.updateStationInChild(newStation);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          MapboxMap(
            // styleString:"https://studio.mapbox.com/tilesets/labib1.clr2aydjt1di91nnmwe9ugjvn-8ygfv", //"labib1.clr2aydjt1di91nnmwe9ugjvn-8ygfv",
            accessToken: MapSample.ACCESS_TOKEN,
            onMapCreated: _onMapCreated,
            onMapClick: (point, coordinates) async {
              List features = await mapController.queryRenderedFeatures(point, ['tufts-campus2'], _featureQueryFilter); // replace with your layer name
              if (features.length > 0 ){
                print(features.first["properties"]["title"]);
                updateStationInChild(features.first["properties"]["title"]);
              }
          },
            myLocationTrackingMode: _myLocationTrackingMode,
            myLocationRenderMode: MyLocationRenderMode.GPS,

          styleString:"mapbox://styles/labib1/clr3pkpnf00x201nt8oeo7a55",



            // cameraTargetBounds: CameraTargetBounds(LatLngBounds(southwest: const LatLng(42, -71), northeast: const LatLng(42.4, -71.1))),
            initialCameraPosition:
            const CameraPosition(
                target: LatLng(42.409, -71.12363),
                zoom: 14.0,
              ),
            onCameraTrackingDismissed: () {
              // Handle camera movement here
              setState((){locationColor = Colors.black;});
              setState(() {
                _myLocationTrackingMode = MyLocationTrackingMode.None;
              });
            },//start map from tufts where it was founded
          ),
          Positioned(
            bottom: 200,
            right:20,
            child: _myLocationTrackingModeCycler()),
          DragWidget(key: childKey),]);

  }
}






