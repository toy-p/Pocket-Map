class Memory {
  Memory(
      {this.idx,
        this.contents,
        required this.dateTime,
        required this.marker_idx,
      });

  int? idx;
  String? contents;
  String dateTime;
  int? marker_idx;

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'contents': contents,
      'dateTime': dateTime,
      'marker_idx': marker_idx,
    };
  }
}