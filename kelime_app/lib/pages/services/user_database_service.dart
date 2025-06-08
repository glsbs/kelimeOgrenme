import 'package:firebase_database/firebase_database.dart';

class UserDatabaseService {
  final _db = FirebaseDatabase.instance.ref();

  Future<void> saveUserToDataBase({
    required String uid,
    required String email,
    required String userName,
  }) async {
    try {
      await _db.child("users").child(uid).set({
        "email": email,
        "totalLearned": 0,
        "newWordCount": 10,
        "userName": userName,
      });
      print(" Kullanıcı verisi kaydedildi");
    } catch (e) {
      print(" Firebase verisi kaydedilemedi: $e");
      rethrow;
    }
  }

  Future<String?> getUserName(String uid) async {
    try {
      final snapshot = await _db.child("users").child(uid).get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        final name = data['userName'] as String?;
        return name;
      }
    } catch (e) {
      print("kullanıcı adı bulunamadı");
    }
    return null;
  }
}

}
