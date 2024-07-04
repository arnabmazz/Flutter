import 'dart:convert';
import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid = 'AC1cce5bd64458f191fa6c34509f401d6c';
  final String authToken = '5c4d107d1d2d4c3872cdd038ea3044e0';
  final String lookupUrl = 'https://lookups.twilio.com/v1/PhoneNumbers/';

  Future<bool> validatePhoneNumber(String phoneNumber) async {
    final response = await http.get(
      Uri.parse('$lookupUrl$phoneNumber'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
      },
    );

    return response.statusCode == 200;
  }
}
