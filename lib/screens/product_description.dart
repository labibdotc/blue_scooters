import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluescooters/widgets/roundedButton.dart';
import 'package:bluescooters/screens/camera.dart';
final firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ProductDescription extends StatefulWidget {
  static const String id = '4';
  final String scooter_id;
  final String scooter_owner;

  ProductDescription({required this.scooter_id, required this.scooter_owner});
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  final _auth = FirebaseAuth.instance;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        // debugPrint(loggedInUser?.email);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  late String scooter_id;
  late String scooter_owner;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    scooter_id = widget.scooter_id;
    scooter_owner = widget.scooter_owner;
  }

  Future<Map<String, dynamic>> getSpecificDocument(String documentId) async {
    try {
      print(documentId);
      // Use the 'scooters' collection and the provided documentId
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('scooters')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        // Document exists, extract and return the desired fields
        //TODEBUG: add ?? "No image";
        var data = documentSnapshot.data();
        var description = data!['description'];
        var speed = data!['speed'];
        var brand = data!['brand'];
        var condition = data!['condition'];
        var light = data!['headlight'];
        var charged_miles = data!['charged_miles'];
        // Return a Map containing the extracted fields
        return {'description': description, 'speed': speed, 'brand': brand, "condition": condition, "headlight": light, "charged_miles": charged_miles};
      } else {
        print('Document does not exist');
        return {};
      }
    } catch (error) {
      print('Error getting document: $error');
      return {};
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSpecificDocument(scooter_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); // Return nothing
          } else if (snapshot.hasError) {
            return Container(); // Return nothing
          } else {
            var scooter_info = snapshot.data as Map<String,dynamic>;
            if (scooter_info == {}) {
              return Container();
            }
            print(scooter_info);
            return Scaffold(
              backgroundColor: Colors.white,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        'images/productDescription.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 28, left: 17.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFEEF9E6),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Color(0xFF6938D3),
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Available to ride!",
                                  style: TextStyle(color: Color(0xFF6938D3)),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 32.0, top: 27),
                          child: Text(scooter_id,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 17.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Tag(text: "${scooter_info["speed"]} MPH+"), //
                                Tag(text: "${scooter_info["charged_miles"]} miles ride or less"),
                                // Tag(text: "< 1 mile radius"), //TODO: decide if this should be removed
                              ]),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0, top: 26),
                          child: Text("Description",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 4),
                          child: Text("From ${scooter_owner}",
                              style: TextStyle(
                                  color: Color(0xFF8C8C8C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(
                              scooter_info["description"],
                              style: TextStyle(
                                  color: Color(0xFF151515),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: 20, right: 20, top: 90, bottom: 27),
                          child: SizedBox(
                            width: 374.0, // Set the width of the SizedBox
                            child: Divider(
                              color: Color(0xFFD9D9D9),
                              thickness: 1, // Set the thickness of the line
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FeatureCard(
                                featureKey: "Brand",
                                value: scooter_info["brand"],
                                featureImagePath: 'images/brand.png',
                              ),
                              FeatureCard(
                                featureKey: "Speed",
                                value: "${scooter_info["speed"]} mph",
                                featureImagePath: 'images/Speed icon.png',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FeatureCard(
                                featureKey: "Light",
                                value: (scooter_info["headlight"]? "Yes": "No"),
                                featureImagePath: 'images/syn.png',
                              ),
                              FeatureCard(
                                featureKey: "Condition",
                                value: scooter_info["condition"],
                                featureImagePath: 'images/condition.png',
                              ),
                            ],
                          ),
                        ),
                        RoundedButton(
                            callback: () async {
                              Navigator.pushNamed(context, CameraApp.id);

                            },
                            color: Color(0xFF6938D3),
                            text: 'Book a Ride!'),
                      ],
                    ),
                  ),
                ],
              ),
            );


          }
        }


    );

  }
}

class Tag extends StatelessWidget {
  Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        children: [
          Material(
              color: Color(0xFFF0F3F6),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              elevation: 0,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(text,
                      style: const TextStyle(
                          color: Color(0xFF696969), fontSize: 12)))),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  FeatureCard(
      {required this.featureKey,
      required this.value,
      required this.featureImagePath});
  final String featureKey;
  final String value;
  final String featureImagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                elevation: 5,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 11),
                    child: Image(
                        image: AssetImage(featureImagePath),
                        width: 36,
                        height: 36))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(featureKey,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B8364)))),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
