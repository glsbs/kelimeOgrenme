import 'package:firebase_database/firebase_database.dart';

class UserWords {
  final _dbRef = FirebaseDatabase.instance.ref();

  Future<String> _addWord(String userId) async {
    final userWordsSnapshot =
        await _dbRef.child('users/$userId/userWords/words').get();

    if (userWordsSnapshot.exists) {
      Map<dynamic, dynamic> userWords =
          userWordsSnapshot.value as Map<dynamic, dynamic>;
      int maxUserWordId = 0;

      userWords.forEach((key, value) {
        int id = int.tryParse(key.replaceAll('word', '')) ?? 0;
        if (id > maxUserWordId) {
          maxUserWordId = id;
        }
      });
      return 'word${(maxUserWordId + 1).toString().padLeft(3, '0')}';
    } else {
      final wordsSnapshot = await _dbRef.child('words').get();
      if (wordsSnapshot.exists) {
        Map<dynamic, dynamic> words =
            wordsSnapshot.value as Map<dynamic, dynamic>;
        int maxWordId = 0;

        words.forEach((key, value) {
          int id = int.tryParse(key.replaceAll('word', '')) ?? 0;
          if (id > maxWordId) {
            maxWordId = id;
          }
        });
        return 'word${(maxWordId + 1).toString().padLeft(3, '0')}';
      } else {
        return 'word001';
      }
    }
  }

  Future<void> kelimeEkle(String userId, Map<String, dynamic> newWord) async {
    try {
      String newWordId = await _addWord(userId);

      if (newWordId.isEmpty) {
        print('DEBUG: Hata: _addWord geçerli bir ID döndürmedi!');

        return;
      }
      String databasePath = 'users/$userId/userWords/words/$newWordId';
      print(
        'DEBUG: RTDB\'ye yazma işlemi başlatılıyor. Hedef yol: $databasePath',
      ); // Adım 5

      await _dbRef.child(databasePath).set(newWord);
      print('hata:  RTDB yazma işlemi BAŞARILI!'); // Adım 6
    } on Exception catch (e) {
      print('hata:  RTDB yazma sırasında bir HATA oluştu: $e');
    }
  }
}
