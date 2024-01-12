import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';


//Server side code
class PaymentsRepository {
  static Random _random = Random();
  static String _cardDetails = "";
  final apiUrl = dotenv.env['API_URL'];


  static String actuallyMakeTheCharge() {
    if(_random.nextBool()) {
      return 'Your credit card was declined';
    }
    return 'Success!';
  }
  static void loadNonce(String nonce) {
    print('loaded nonce!');
    _cardDetails = nonce;
  }
}