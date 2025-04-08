import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/concert.dart';

class ConcertListScreen extends StatefulWidget {
  const ConcertListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConcertListScreenState createState() => _ConcertListScreenState();
}

class _ConcertListScreenState extends State<ConcertListScreen> {
  late Future<List<Concert>> _concerts;

  @override
  void initState() {
    super.initState();
    _concerts =
        ApiService.fetchConcerts(); // Récupération des concerts depuis l'API
  }

  void _addToFavorites(BuildContext context, Concert concert) {
    // Ajoute un concert aux favoris (peut être stocké en local ou en base de données)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${concert.artiste} ajouté aux favoris"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Thème sombre comme Spotify
      appBar: AppBar(
        title: const Text('Concerts à venir',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Concert>>(
        future: _concerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Erreur: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun concert trouvé.',
                  style: TextStyle(color: Colors.white)),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Concert concert = snapshot.data![index];
                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      concert.artiste,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      '${concert.date} - ${concert.lieu}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.green),
                      onPressed: () => _addToFavorites(context, concert),
                    ),
                    onTap: () {
                      // Naviguer vers une page de détails du concert (à implémenter)
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
