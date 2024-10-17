import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NHLService {
  static const String baseUrl = 'https://api-web.nhle.com/v1';

  // Hakee aikataulut ja perustiedot
  Future<Map<String, dynamic>> fetchSchedule(DateTime date) async {;
    final String newDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await http.get(Uri.parse('$baseUrl/score/$newDate'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load schedule');
    }
  }
  

  // Hakee tarkempia ottelutietoja
  Future<Map<String, dynamic>> fetchGameDetails(String gameId) async {
    final response = await http.get(Uri.parse('$baseUrl/gamecenter/$gameId/right-rail'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load game details');
    }
  }

}