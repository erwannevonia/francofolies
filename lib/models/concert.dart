class Concert {
  final int id;
  final String artiste;
  final String date;
  final String scene;

  Concert({
    required this.id,
    required this.artiste,
    required this.date,
    required this.scene,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['ID_CONCERT'],
      artiste: json['NOM_ARTISTE'],
      date: json['DATE_SHOW'],
      scene: json['NOM_SCENE'],
    );
  }
}
