class Concert {
 final int id;
 final String artiste;
 final String date;
 final String lieu;
 Concert({required this.id, required this.artiste, required this.date,
required this.lieu});
 factory Concert.fromJson(Map<String, dynamic> json) {
 return Concert(
 id: json['id'],
 artiste: json['artiste'],
 date: json['date'],
 lieu: json['lieu'],
 );
 }
}