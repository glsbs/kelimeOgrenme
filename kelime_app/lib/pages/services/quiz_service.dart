import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:kelime_app/models/user_word_data.dart';
import 'package:kelime_app/models/word_model.dart';
import 'package:intl/intl.dart';

class QuizService {
  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getQuizWords() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final userRef = _db.child("users/${user.uid}");

    final userWordDataSnapshot =
        await userRef.child("userWords/correctWords").get();
    final wordDataSnapshot = await _db.child("words").get();
    final newWordCountSnapshot = await userRef.child("newWordCount").get();

    int newWordCount =
        int.tryParse(newWordCountSnapshot.value.toString()) ?? 10;

    final Map<dynamic, dynamic> allWords = wordDataSnapshot.value as Map;
    final Map<dynamic, dynamic> userWordDataMap =
        userWordDataSnapshot.value as Map? ?? {};
    if (allWords == null) {
      print("Kelimeler alınamadı");
      return [];
    }
    //word objelerine çevirir
    List<Word> allWordsMap =
        allWords.entries
            .map((entry) => Word.fromMap(entry.key, entry.value))
            .toList();
    Map<String, UserWordData> userWordData = {};

    if (userWordDataMap != null) {
      userWordDataMap.forEach((key, value) {
        userWordData[key.toString()] = UserWordData.fromMap(
          key.toString(),
          value,
        );
        ;
      });
    }

    List<String> eligibleWordIds = [];

    for (var word in allWordsMap) {
      final userWord = userWordData[word.id];
      if (userWord == null || !userWord.isKnown) {
        eligibleWordIds.add(word.id);
      }
      // Eğer hiç çözülmemişse veya 6 tekrar tamamlanmamışsa eklemek için
    }

    //Uygun kelimeleri rastgele karıştır
    eligibleWordIds.shuffle();
    List<Word> selectedWords =
        eligibleWordIds
            .take(newWordCount)
            .map((id) => allWordsMap.firstWhere((word) => word.id == id))
            .toList();

    List<Map<String, dynamic>> quizList = [];

    for (var word in selectedWords) {
      List<String> wrongOptions = [];
      List<Word> shuffledAllWords = List.from(allWordsMap)..shuffle();

      for (var otherWord in shuffledAllWords) {
        if (otherWord.id != word.id) {
          wrongOptions.add(otherWord.turkWord);
          if (wrongOptions.length >= 3) break;
        }
      }
      while (wrongOptions.length < 3) {
        wrongOptions.add("Yanlış seçenek ${wrongOptions.length + 1}");
      }

      List<String> options = [...wrongOptions, word.turkWord]..shuffle();

      quizList.add({
        "wordId": word.id,
        "ingWord": word.ingWord,
        "turkWord": word.turkWord,
        "samples": word.samples,
        "imageUrl": word.imageUrl,
        "options": options,
      });
    }
    return quizList;
  }

  Future<void> updateUserWordData(String wordId, bool isCorrect) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _db.child(
      "users/${user.uid}/userWords/correctWords/$wordId",
    );

    final snapshot = await userRef.get();

    final today = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(today);

    int correctCount = 0;
    List<String> correctDates = [];

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      correctCount = int.tryParse(data["correctCount"]?.toString() ?? "0") ?? 0;

      final List<dynamic>? saveDates = data["correctDates"] as List?;
      correctDates = saveDates?.map((e) => e.toString()).toList() ?? [];

      if (!isCorrect) {
        await userRef.remove();
        return;
      }
    }
    if (!correctDates.contains(todayStr)) {
      correctDates.add(todayStr);
      correctCount++;
    }

    List<int> targetDays = [0, 1, 7, 30, 90, 180];
    int tolerance = 2;

    bool isKnown = targetDays.every(
      (d) => correctDates.any((ds) {
        try {
          final date = DateTime.parse(ds);
          final diff = today.difference(date).inDays;

          return (diff - d).abs() <= tolerance;
        } catch (e) {
          print("Tarih hatası ");
          return false;
        }
      }),
    );

    await userRef.update({
      "correctDates": correctDates,
      "isKnown": isKnown,
      "correctCount": correctCount,
      "lastCorrectDate": todayStr,
    });
  }
}
