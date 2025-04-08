class Concert {
  final int id;
  final String artiste;
  final String date;
  final String lieu;
  final String scene; // Ajout de la scène
  final List<String> artistes; // Liste des artistes
  final double tarif; // Ajout du tarif

  Concert({
    required this.id,
    required this.artiste,
    required this.date,
    required this.lieu,
    required this.scene,
    required this.artistes,
    required this.tarif,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['id'] ?? 0, // Valeur par défaut
      artiste: json['artiste'] ?? "Inconnu", // Valeur par défaut
      date: json['date'] ?? "Date inconnue", // Valeur par défaut
      lieu: json['lieu'] ?? "Lieu inconnu", // Valeur par défaut
      scene: json['scene'] ?? "Scène inconnue", // Valeur par défaut
      artistes: json['artistes'] != null
          ? List<String>.from(json['artistes'])
          : [], // Liste vide si 'artistes' est nul
      tarif: json['tarif'] != null
          ? json['tarif'].toDouble()
          : 0.0, // Valeur par défaut
    );
  }
}
