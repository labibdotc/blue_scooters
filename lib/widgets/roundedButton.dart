import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  Color color;
  String text;
  Function callback;

  RoundedButton({required this.callback, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Material(
        elevation: 0.0,
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: () {
            callback.call();
          },
          minWidth: 100.0,
          height: 42.0,
          child: Text(
              text,
            style:TextStyle(color: Colors.white,) ,
          ),
        ),
      ),
    );
  }
}