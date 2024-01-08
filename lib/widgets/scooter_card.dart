import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bluescooters/screens/product_description.dart';
//scooter representation in the dragable menu
class scooterCard extends StatefulWidget {
  scooterCard(
      {required this.owner,
        required this.name,
        required this.image});
  final String owner;
  final String name;
  final String image;
  @override
  State<scooterCard> createState() => _scooterCardState();
}
class _scooterCardState extends State<scooterCard> {
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
              print('Button pressed!');
              Navigator.pushNamed(context, ProductDescription.id);
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
                            child: Text(owner,
                                style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
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