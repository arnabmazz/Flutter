import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryRepository {
  final String namesUrl = 'http://country.io/names.json';
  final String phoneUrl = 'http://country.io/phone.json';

  Future<List<Country>> fetchCountries() async {
    final namesResponse = await http.get(Uri.parse(namesUrl));
    final phoneResponse = await http.get(Uri.parse(phoneUrl));

    if (namesResponse.statusCode == 200 && phoneResponse.statusCode == 200) {
      final names = json.decode(namesResponse.body) as Map<String, dynamic>;
      final phones = json.decode(phoneResponse.body) as Map<String, dynamic>;

      List<Country> countries = names.keys.map((key) {
        return Country(names[key], phones[key]);
      }).toList();

      return countries;
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
