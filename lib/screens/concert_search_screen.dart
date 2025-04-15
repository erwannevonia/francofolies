import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/concert.dart';

class ConcertSearchScreenPage extends StatefulWidget {
  const ConcertSearchScreenPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConcertSearchScreenPageState createState() =>
      _ConcertSearchScreenPageState();
}

class _ConcertSearchScreenPageState extends State<ConcertSearchScreenPage> {
  final TextEditingController sceneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController artisteController = TextEditingController();

  List<Concert> concerts = [];

  final ApiService apiService = ApiService();

  void _searchConcerts() async {
    var results = await apiService.searchConcerts(
      sceneController.text,
      dateController.text,
      artisteController.text,
    );
    setState(() {
      concerts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recherche avancée')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: sceneController,
              decoration: InputDecoration(labelText: 'Scène'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: artisteController,
              decoration: InputDecoration(labelText: 'Artiste'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchConcerts,
              child: Text('Rechercher'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: concerts.length,
                itemBuilder: (context, index) {
                  var concert = concerts[index];
                  return ListTile(
                    title: Text(concert.artiste),
                    subtitle: Text(
                        "Lieu: ${concert.lieu}\nScène: ${concert.scene}\nDate: ${concert.date}\nTarif: ${concert.tarif}€"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
