import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/concert.dart';

class ApiService {
  static const String baseUrl =
      'http://127.0.0.1:3000'; //Modifier l'adresse IP du serveur

  static Future<List<Concert>> getConcerts() async {
    final response = await http.get(Uri.parse('$baseUrl/concerts'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((concert) => Concert.fromJson(concert)).toList();
    } else {
      throw Exception('Failed to load concerts');
    }
  }
}
