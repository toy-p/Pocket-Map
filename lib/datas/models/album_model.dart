class Album {
  Album({
    this.title,
    this.place,
    required this.dateTime,
    this.picture,
    this.content,
  });

  String? title;
  String? place;
  String dateTime;
  List<String>? picture;
  String? content;
}
