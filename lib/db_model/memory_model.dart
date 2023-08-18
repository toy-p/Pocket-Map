class MemoryModel {
  factory MemoryModel.fromMap(Map map) {
    return MemoryModel(
      idx: map['idx'],
      contents: map['contents'],
      datetime: map['datetime'],
      marker_idx: map['marker_idx'],
    );
  }
  MemoryModel({
    this.idx,
    required this.contents,
    required this.datetime,
    required this.marker_idx,
  });

  int? idx;
  String contents = '';
  String datetime;
  int? marker_idx;

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'contents': contents,
      'datetime': datetime,
      'marker_idx': marker_idx,
    };
  }
}
