class UserWordData {
  final String wordId;
  final int correctCount;
  final List<String> correctDates;
  final bool isKnown;
  final String? lastCorrectDate;

  UserWordData({
    required this.wordId,
    required this.correctCount,
    required this.correctDates,
    required this.isKnown,
    required this.lastCorrectDate,
  });
  factory UserWordData.fromMap(String wordId, Map<dynamic, dynamic> data) {
    return UserWordData(
      wordId: wordId,
      correctCount: data["correctCount"] ?? 0,
      correctDates: List<String>.from(data['correctDates'] ?? []),
      isKnown: data["isKnown"] ?? false,
      lastCorrectDate: data["lastCorrectDate"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correctCount': correctCount,
      'isKnown': isKnown,
      'lastCorrectDates': correctDates,
      if (lastCorrectDate != null) 'lastCorrectDate': lastCorrectDate,
    };
  }
}
