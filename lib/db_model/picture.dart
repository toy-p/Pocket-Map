class Picture {
  Picture(
      {this.idx,
        required this.marker_idx,
        required this.memory_idx,
        this.picture,
      });

  int? idx;
  int marker_idx;
  int memory_idx;
  String? picture;

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'memory_idx' : memory_idx,
      'picture' : picture,
      'marker_idx': marker_idx,
    };
  }
}