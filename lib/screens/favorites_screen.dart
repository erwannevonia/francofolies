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

    int userId = 1;

    void _addToFavorites(BuildContext context, Concert concert) {
    // Ajoute un concert aux favoris (peut être stocké en local ou en base de données)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${concert.artiste} ajouté aux favoris"),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Fermer',
          onPressed: () {
            // Some code to undo the change
          },
        ),
      ),
    );
  }

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
                      'Lieu: ${concert.scene}\nDate: ${concert.date}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: Consumer<FavorisProvider>(
                      builder: (context, favorisProvider, _) {
                        final isFavori =
                            favorisProvider.isFavori(concert.id);
                        return IconButton(
                          icon: Icon(
                            isFavori
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            favorisProvider.toggleFavori(
                                userId, concert.id);
                            _addToFavorites(context, concert);
                          },
                        );
                      },
                    ),
                    onTap: () {
                      // Navigation vers les détails (à faire plus tard)
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
