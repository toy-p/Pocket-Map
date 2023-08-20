class MarkerModel {
  MarkerModel({
    this.id,
    required this.title,
    this.icon_codepoint,
    this.picture,
    required this.lati,
    required this.longi,
    this.place,
  });

  factory MarkerModel.fromMap(Map<String, dynamic> map) {
    return MarkerModel(
      id: map['id'],
      title: map['title'],
      icon_codepoint: map['icon_codepoint'],
      picture: map['picture'],
      lati: map['lati'],
      longi: map['longi'],
      place: map['place'],
    );
  }
  int? id;
  String title;
  int? icon_codepoint;
  String? picture;
  double lati;
  double longi;
  String? place;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon_codepoint': icon_codepoint,
      'picture': picture,
      'lati': lati,
      'longi': longi,
      'place': place,
    };
  }
}
