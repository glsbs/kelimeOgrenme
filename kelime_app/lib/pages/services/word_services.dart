import 'package:firebase_database/firebase_database.dart';
import 'package:kelime_app/models/word_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WordService {
  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  Future<List<Word>> getCombinedWords() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return await _fetchGeneralWords();
    }
    final String uid = currentUser.uid;

    final results = await Future.wait([
      _fetchGeneralWords(),
      _fetchUserAddedWords(uid),
    ]);
    List<Word> generalWords = results[0];
    List<Word> userAddedWords = results[1];

    List<Word> combinedList = [...generalWords];
    Set<String> generalWordIds = generalWords.map((w) => w.id).toSet();
    for (var userWord in userAddedWords) {
      if (!generalWordIds.contains(userWord.id)) {
        combinedList.add(userWord);
      } else {
        print(
          "Uyarı: ${userWord.id} ID'li kelime hem genel hem de kullanıcı listesinde var. Genel versiyon tutuluyor.",
        );
      }
    }

    return combinedList;
  }

  Future<List<Word>> _fetchGeneralWords() async {
    final generalWordsRef = _db.child('words');
    final snapshot = await generalWordsRef.once();
    final wordsMap = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (wordsMap == null) {
      return [];
    }
    List<Word> wordList = [];
    wordsMap.forEach((wordId, wordData) {
      if (wordData is Map) {
        try {
          final word = Word.fromMap(wordId.toString(), wordData);
          wordList.add(word);
        } catch (e) {
          print("hata:$e");
        }
      } else {
        print("Genel kelime $wordId doğru formatta değil");
      }
    });
    return wordList;
  }

  Future<List<Word>> _fetchUserAddedWords(String uid) async {
    final userAddedWordsRef = _db
        .child('users')
        .child(uid)
        .child('userWords')
        .child('words');

    final snapshot = await userAddedWordsRef.once();
    final wordsMap = snapshot.snapshot.value as Map<dynamic, dynamic>?;
    if (wordsMap == null) {
      return [];
    }

    List<Word> wordList = [];
    wordsMap.forEach((wordId, wordData) {
      if (wordData is Map) {
        try {
          final word = Word.fromMap(wordId.toString(), wordData);
          wordList.add(word);
        } catch (e) {
          print("hata: $wordId dönüştürülemedi:$e");
        }
      } else {
        print("Kullanıcı kelimesi$wordId doğru formatta değil");
      }
    });
    return wordList;
  }
}
