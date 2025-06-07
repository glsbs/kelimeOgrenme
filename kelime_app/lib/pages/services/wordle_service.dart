import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kelime_app/models/word_model.dart';
import 'package:kelime_app/models/user_word_data.dart';

class WordleService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<Word?> getRandomKnownWord() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final String uid = user.uid;
    try {
      final userWordSnapshot =
          await _db.ref().child("users/$uid/userWords/correctWords").get();
      if (!userWordSnapshot.exists) return null;

      final generalWordsSnapshot = await _db.ref().child("words").get();
      if (!generalWordsSnapshot.exists) return null;

      final Map<dynamic, dynamic> correctWordsMap =
          userWordSnapshot.value as Map<dynamic, dynamic>;
      final Map<dynamic, dynamic> generalWordsMap =
          generalWordsSnapshot.value as Map<dynamic, dynamic>;

      final List<Word> knownWords = [];
      correctWordsMap.forEach((key, value) {
        final wordId = key.toString();

        if (generalWordsMap.containsKey(wordId)) {
          knownWords.add(Word.fromMap(wordId, generalWordsMap[wordId]));
        }
      });

      if (knownWords.isEmpty) return null;
      knownWords.shuffle();
      return knownWords.first;
    } catch (e) {
      print("Hata:$e");
      return null;
    }
  }
}
