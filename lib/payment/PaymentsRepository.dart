import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bluescooters/db/SquareUserData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';





//Server side code
class PaymentsRepository {
  static Random _random = Random();
  static final apiUrl = dotenv.env['API_URL'];

  static Future<http.Response> chargeForCookie(String nonce) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = '$apiUrl/chargeForCookie';
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
  static Future<http.Response> chargeForARide(String nonce, String square_id, String scooter_id, String owner_name, double amount) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = '$apiUrl/chargeCustomerCard';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: '{"customer_id": "$square_id", "customer_card_id": "$nonce", "scooter_id": "$scooter_id", "owner_name": "$owner_name", "amount": "$amount"}',
    );
    return response;
  }
  static Future<String> getCardDetailsFromSquare(String? user_id) async {
    final apiUrl = dotenv.env['API_URL'];
    print(user_id);
    final url = '$apiUrl/v2/customers/$user_id';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception("Card not available on file. Please contact developer!");
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    // Access the "error_message" field
    var cards = jsonResponse['cards'];
    if (cards == '[]') {
      throw Exception("This user have no credit card record!");
    }
    //return nonce of card
    var card = jsonResponse['cards'][0]['id'];
    return card;
  }
  static Future<String> actuallyMakeTheCharge(String scooter_id, String owner_name, double payment_amount) async {
    try {
      String? user_id;
      final user = FirebaseAuth.instance.currentUser!;
      if (user == null) {
        throw Exception("user is nil!");
      } else {
        user_id = user?.email;
      }
      var square_id = await SquareUserData.getUserSquareID(user_id);
      var _cardDetails = await getCardDetailsFromSquare(square_id);
      http.Response r = await chargeForARide(_cardDetails, square_id, scooter_id, owner_name, payment_amount);
      //TODO: remove debugging
      //     print(_cardDetails);
      //     print(r.body);
          print(r.statusCode);
      if (r.statusCode == 200) {
        return 'Success!';//TODO: bring down
      } else{
        Map<String, dynamic> jsonResponse = json.decode(r.body);

        // Access the "error_message" field
        var errorMessage = jsonResponse['errorMessage'];
        return errorMessage;
      }
    } catch(e) {
      return e.toString();
    }




  }
  static Future<http.Response> createCardInSquare(String nonce, String? customer_id) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = '$apiUrl/createCustomerCard';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customer_id': customer_id,
        'nonce': nonce,
      }),
    );
    return response;
  }
  static Future<void> loadNonce(String nonce, String? user_id) async {
    http.Response r = await createCardInSquare(nonce, user_id);
    print(r.statusCode);
    if (r.statusCode != 200) {
      Map<String, dynamic> jsonResponse = json.decode(r.body);
      throw Exception(jsonResponse["errorMessage"]);
    }
  }
  //returns id of user in square
  static Future<String> createSquareUser(String email) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = '$apiUrl/v2/customers';

    final r = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email_address': email,
      }),
    );
    print(r.body);
    print(r.statusCode);
    Map<String, dynamic> jsonResponse = json.decode(r.body);
    if (r.statusCode != 200) {

      throw Exception(jsonResponse["errorMessage"]);
    }

    // Access the "error_message" field
    var id = jsonResponse['id'];
    return id;
  }

}

