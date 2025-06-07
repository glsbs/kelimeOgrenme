import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class StatisticsService {
  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  String? get _uid => _user?.uid;

  Future<int> learnedWordCount() async {
    if (_uid == null) return 0;

    final userRef = _db.child("users/$_uid/userWords/correctWords");
    final snapshot = await userRef.get();

    if (!snapshot.exists) return 0;

    final Map<dynamic, dynamic> userWordsMap = snapshot.value as Map;
    int learnedCount = 0;

    userWordsMap.forEach((key, value) {
      if (value["isKnown"] == true) {
        learnedCount++;
      }
    });
    return learnedCount;
  }

  Future<Map<String, int>> dailyCorrectCounts() async {
    if (_uid == null) return {};
    final snapshot =
        await _db.child("users/$_uid/userWords/correctWords").get();

    if (!snapshot.exists) return {};

    final data = snapshot.value as Map;

    Map<String, int> dailyCounts = {};

    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');

    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final dateStr = dateFormatter.format(day);
      dailyCounts[dateStr] = 0;
    }

    for (var value in data.values) {
      if (value is Map && value["correctDates"] != null) {
        final List<dynamic> dates = value["correctDates"];

        for (var d in dates) {
          if (d is String && dailyCounts.containsKey(d)) {
            dailyCounts[d] = (dailyCounts[d] ?? 0) + 1;
          }
        }
      }
    }
    return dailyCounts;
  }
}
