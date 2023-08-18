class PictureModel {
  factory PictureModel.fromMap(Map map) {
    return PictureModel(
      idx: map['idx'],
      memory_idx: map['memory_idx'],
      picture: map['picture'],
    );
  }
  PictureModel({
    this.idx,
    required this.memory_idx,
    required this.picture,
  });

  int? idx;
  int memory_idx;
  String? picture;

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'memory_idx': memory_idx,
      'picture': picture,
    };
  }
}
