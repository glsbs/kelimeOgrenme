import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_database_service.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print("Auth: createUserWithEmailAndPassword tamamlandı");

      if (result.user != null) {
        final uid = result.user!.uid;
        print(" UID oluşturuldu: $uid");

        await UserDatabaseService().saveUserToDataBase(
          uid: uid,
          email: email,
          userName: userName,
        );
        print(" RTDB SAVE BAŞARILI: Kullanıcı verisi kaydedildi.");
      } else {
        throw Exception("Kullanıcı bilgisi alınamadı.");
      }
    } on FirebaseAuthException catch (e) {
      print(" FirebaseAuth hatası: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print(
        " Kullanıcı oluşturulurken veya veritabanına yazılırken hata oluştu: $e",
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
