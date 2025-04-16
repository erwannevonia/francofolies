import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favoris_provider.dart';
import '../services/api_service.dart';
import '../models/concert.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorisProvider = Provider.of<FavorisProvider>(context);
    final favorisIds = favorisProvider.favoris.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mes Favoris', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Concert>>(
        future: ApiService.getConcertsByIds(favorisIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun favori pour l’instant.',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            );
          } else {
            return ListView(
              children: snapshot.data!
                  .map((concert) => ListTile(
                        title: Text(concert.artiste,
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text('${concert.scene} - ${concert.date}',
                            style: TextStyle(color: Colors.grey)),
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
