import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;



//Server side code
class PaymentsRepository {
  static Random _random = Random();
  static String _cardDetails = "";
  static final apiUrl = dotenv.env['API_URL'];

  static Future<http.Response> chargeForCookie(String nonce) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = '$apiUrl';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: '{"nonce": "$nonce"}',
    );
    return response;
    // Handle the response as needed
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  static String actuallyMakeTheCharge() {
    var isCharged = false;
    chargeForCookie(_cardDetails).then(
            (http.Response r) {
              print(_cardDetails);
              print(r.body);
              if (r.statusCode == 200) {
                isCharged = true;
              }});

    if(!isCharged) {
      return 'Your credit card was declined';
    }
    return 'Success!';
  }
  static void loadNonce(String nonce) {
    print('loaded nonce!');
    print(apiUrl);
    _cardDetails = nonce;
  }
}