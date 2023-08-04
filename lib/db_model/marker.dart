class dbMarker {
  dbMarker(
      {this.id,
        this.place,
        required this.lati,
        required this.longi,
      });

  int? id;
  String? place;
  double lati;
  double longi;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place': place,
      'lati' : lati,
      'longi' : longi,
    };
  }
}