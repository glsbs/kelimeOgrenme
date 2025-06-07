class Word {
  final String id;
  final String ingWord;
  final String turkWord;
  final String samples;
  final String? imageUrl;
  final String? audioUrl;
  final String? type;

  Word({
    required this.id,
    required this.ingWord,
    required this.turkWord,
    required this.samples,
    this.imageUrl,
    this.audioUrl,
    this.type,
  });

  factory Word.fromMap(String id, Map<dynamic, dynamic> data) {
    return Word(
      id: id,
      ingWord: data["ingWord"] ?? "",
      turkWord: data["turkWord"] ?? "",
      samples: data["samples"] ?? "",
      imageUrl: data["imageUrl"],
      audioUrl: data["audio"],
      type: data["type"] ?? "",
    );
  }
}
