import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/concert.dart';

class ApiService {
  static const String baseUrl =
      'http://172.16.198.254:3000'; //Modifier l'adresse IP du serveur

  static Future<List<Concert>> getConcerts() async {
    final response = await http.get(Uri.parse('$baseUrl/concert'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((concert) => Concert.fromJson(concert)).toList();
    } else {
      throw Exception('Failed to load concerts');
    }
  }

  Future<List<Concert>> searchConcerts(
      String scene, String date, String artiste) async {
    final response = await http.get(Uri.parse(
      '$baseUrl/concerts?scene=$scene&date=$date&artiste=$artiste',
    ));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((concert) => Concert.fromJson(concert)).toList();
    } else {
      throw Exception('Failed to load concerts');
    }
  }

  static Future<List<Concert>> fetchConcerts(
      String? scene, String? date, String? artiste) async {
    final queryParameters = {
      if (scene != null && scene.isNotEmpty) 'scene': scene,
      if (date != null && date.isNotEmpty) 'date': date,
      if (artiste != null && artiste.isNotEmpty) 'artiste': artiste,
    };

    final uri = Uri.http(baseUrl, '/concerts', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des concerts');
    }
  }
}
