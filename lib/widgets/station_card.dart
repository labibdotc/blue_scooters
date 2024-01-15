import 'package:flutter/material.dart';
//scooter representation in the dragable menu
class stationCard extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  stationCard(
      {required this.name,
        required this.image,
      required this.onPressed,
      required this.isSelected});
  final String name;
  final String image;
  @override
  State<stationCard> createState() => _stationCardState();
}
class _stationCardState extends State<stationCard> {
  late String name;
  late String image;
  late bool isSelected;
  late VoidCallback onPressed;
  @override
  void initState() {
    super.initState();
    // Initialize the state variable with the widget's parameter
    name = widget.name;
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.all( Radius.circular(12),),
          borderOnForeground: true,
          elevation: widget.isSelected ? 5 : 0,
          child: InkWell(
            onTap: () {
              widget.onPressed();
            },
            onTapDown: (_) {
              // Set the state to indicate button press

            },
            onTapUp: (_) {
              // Set the state to indicate button release

            },
            onTapCancel: () {
              // Handle tap cancellation (e.g., user swiped away)

            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: widget.isSelected ? Color(0xFF6938D3) : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color(0xFF6938D3), // Set the color of the border
                  width: 1.0, // Set the width of the border
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30),

                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11),
                          child:  Icon(Icons.location_on, color: widget.isSelected ? Colors.white: Colors.black)
                              // icon: ,
                              // width: 60,
                              // height: 60)),
                    ),),
                    Center(
                      child: Text(name,
                          style:  TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: widget.isSelected ? Colors.white: Colors.black)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}