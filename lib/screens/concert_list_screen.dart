import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/concert.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/favoris_provider.dart';

class ConcertListScreen extends StatefulWidget {
  const ConcertListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConcertListScreenState createState() => _ConcertListScreenState();
}

class _ConcertListScreenState extends State<ConcertListScreen> {
  late Future<List<Concert>> _concerts;

  bool onlyBorder = true;

  int userId = 1;

  final TextEditingController artisteController = TextEditingController();
  final TextEditingController sceneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _concerts =
        ApiService.getConcerts(); // Récupération des concerts depuis l'API

    onlyBorder = true;
  }

  void _reset() {
    artisteController.text = '';
    sceneController.text = '';
    dateController.text = '';
    setState(() {
      _concerts =
          ApiService.getConcerts(); // Récupération des concerts depuis l'API
    });
  }

  void _searchConcerts() {
    final dateText = dateController.text;
    String? formattedDate;

    if (dateText.isNotEmpty) {
      try {
        final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(dateText);
        formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        print("Erreur de parsing date : $e");
      }
    }

    setState(() {
      _concerts = ApiService.fuiteConcerts(
        artiste: artisteController.text.trim(),
        scene: sceneController.text.trim(),
        date: formattedDate,
      );
    });
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
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      TextField(
                        controller: artisteController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Artiste',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      TextField(
                        controller: sceneController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Scène',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      TextField(
                        controller: dateController,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Color.fromARGB(0, 158, 158, 158),
                          border: OutlineInputBorder(),
                          suffixIcon:
                              Icon(Icons.calendar_today, color: Colors.white),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                    surface: Colors.black,
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            String formatted =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            setState(() {
                              dateController.text = formatted;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ou spaceBetween, ou center selon ce que tu veux
                        children: [
                          ElevatedButton(
                            onPressed: _searchConcerts,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Rechercher'),
                          ),
                          ElevatedButton(
                            onPressed: _reset,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Vider les filtres'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
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
                                  // ignore: unnecessary_string_interpolations
                                  String artiste = '${concert.artiste}';
                                  favorisProvider.toggleFavori(
                                      userId, concert.id, artiste, context);
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
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}
