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

  static Future<List<Concert>> fuiteConcerts({
    String? scene,
    String? date,
    String? artiste,
  }) {
    return fetchConcerts(scene, date, artiste);
  }

  static Future<List<Concert>> fetchConcerts(
      String? scene, String? date, String? artiste) async {
    final queryParameters = {
      if (scene != null && scene.isNotEmpty) 'scene': scene,
      if (date != null && date.isNotEmpty) 'date': date,
      if (artiste != null && artiste.isNotEmpty) 'artiste': artiste,
    };

    final uri = Uri.parse('$baseUrl/concerts')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des concerts');
    }
  }

  static Future<void> addFavori(int? userId, int? concertId) async {
    final queryParameters = {
      if (userId != null) 'userId': userId,
      if (concertId != null) 'concertId': concertId,
    };

    final uri = Uri.parse('$baseUrl/addFavori')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Erreur d\'ajout du concert en favori');
    }
  }

  static Future<void> removeFavori(int? userId, int? concertId) async {
    final queryParameters = {
      if (userId != null) 'userId': userId,
      if (concertId != null) 'concertId': concertId,
    };

    final uri = Uri.parse('$baseUrl/removeFavori')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Erreur de la supppression du concert en favori');
    }
  }

  static Future<List<Concert>> getConcertsByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    final uri = Uri.http(baseUrl, '/concerts/byIds', {'ids': ids.join(',')});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Concert.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des favoris");
    }
  }
}
