import 'package:flutter/material.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
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
  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId('sandbox-sq0idb-O4lvBauO1sZhztTGGrAqMw');
  }
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
  /**
   * An event listener to start card entry flow
   */
  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  /**
   * Callback when card entry is cancelled and UI is closed
   */
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
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
      print('success!');
      // payment finished successfully
      // you must call this method to close card entry
      // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  /**
   * Callback when the card entry is closed after call 'completeCardEntry'
   */
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
    print("card entry complete");
  }

  @override
  void initState() {
    print("initializing payment screen");

    super.initState();

    // Initialize Square payment
    // _initSquarePayment();
    //
    // // Set iOS card entry theme if running on iOS
    // if (Platform.isIOS) {
    //   _setIOSCardEntryTheme();
    // }
    //
    // // Start the card entry flow
    // _onStartCardEntryFlow();
  }
  _payment() async {
    await _initSquarePayment();
    await _onStartCardEntryFlow();
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
                _payment();
              },
              child: Text('Cash and fly!'),
            ),
          ],
        ),
      )

    );
  }
}
