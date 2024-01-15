import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/screens/product_description.dart';
//scooter representation in the dragable menu
class stationCard extends StatefulWidget {
  stationCard(
      {required this.owner,
        required this.name,
        required this.image});
  final String owner;
  final String name;
  final String image;
  @override
  State<stationCard> createState() => _stationCardState();
}
class _stationCardState extends State<stationCard> {
  late String owner;
  late String name;
  late String image;
  @override
  void initState() {
    super.initState();
    // Initialize the state variable with the widget's parameter
    owner = widget.owner;
    name = widget.name;
    image = widget.image;
  }
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.all( Radius.circular(12),),
          borderOnForeground: true,
          elevation: isButtonPressed ? 5 : 0,
          child: InkWell(
            onTap: () {
              // Handle button press
              // print('Button pressed!'); //TODO: remove in production
              Navigator.pushNamed(context, ProductDescription.id,
                arguments: {
                'scooter_id': name,
                  'scooter_owner': owner,
                  'payment_amount': 1.06
                },
              );
            },
            onTapDown: (_) {
              // Set the state to indicate button press
              setState(() {
                isButtonPressed = true;
              });
            },
            onTapUp: (_) {
              // Set the state to indicate button release
              setState(() {
                isButtonPressed = false;
              });
            },
            onTapCancel: () {
              // Handle tap cancellation (e.g., user swiped away)
              setState(() {
                isButtonPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isButtonPressed ? Color(0xFF6938D3) : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color(0xFF6938D3), // Set the color of the border
                  width: 1.0, // Set the width of the border
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30),

                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11),
                          child: Image(
                              image: AssetImage(image),
                              width: 60,
                              height: 60)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(name,
                              style:  TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: isButtonPressed ? Colors.white: Colors.black)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text('\$0.99 per 30 mins', //Used to be owner
                                style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100,
                                    color: isButtonPressed ? Colors.white: Color(0xFF4B8364)))),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}