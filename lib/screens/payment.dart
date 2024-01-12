import 'package:bluescooters/payment/PaymentsRepository.dart';
import 'package:flutter/material.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:bluescooters/screens/InTrip.dart';
import 'dart:io';


class Payment extends StatefulWidget {
  static const String id = '11';
  final int payment_amount;
  final String owner_id;
  final String rider_id;

  Payment({required this.payment_amount, required this.owner_id, required this.rider_id});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment>{

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
    print("initializing payment screen");

    super.initState();

    // Initialize Square payment
    // _initSquarePayment();
    //
    // // Set iOS card entry theme if running on iOS
    if (Platform.isIOS) {
      _setIOSCardEntryTheme();
    }
    //
    // // Start the card entry flow
    // _onStartCardEntryFlow();
  }

  @override
  Widget build(BuildContext context) {
    print("building payment screen");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('\$\$'),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your payment UI components here
            Text(
              'Welcome to the Payment Page!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            // Example: Display payment amount
            Text(
              'Amount: \$${widget.payment_amount}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Trigger the card entry flow when the button is pressed
                print("Processing payment logic");
                var result = PaymentsRepository.actuallyMakeTheCharge();
                if (result == 'Success!') {
                  print("Payment went through");
                  print("Camera: take pictures with instructions");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InTrip()));
                } else {
                  print(result);
                }

              },
              child: Text('Cash and fly!'),
            ),
          ],
        ),
      )

    );
  }
}
