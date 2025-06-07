import 'package:flutter/material.dart';
import 'package:kelime_app/pages/auth/forgot_password.dart';
import 'package:kelime_app/pages/auth/login_page.dart';
import 'package:kelime_app/pages/auth/signup_page.dart';
import 'package:kelime_app/pages/ayarlar_page.dart';
import 'package:kelime_app/pages/home_page.dart';
import 'package:kelime_app/pages/kelime_ekle.dart';
import 'package:kelime_app/pages/kelimelerim_page.dart';
import 'package:kelime_app/pages/quiz_page.dart';
import 'package:kelime_app/pages/statistics_page.dart';
import 'package:kelime_app/pages/wordle_page.dart';

class AppRoutes {
  static const String home = "/HomePage";
  static const String login = "/LoginPage";
  static const String signup = "/SignupPage";
  static const String quiz = "/QuizPage";
  static const String forgotPassword = "/ForgotPassword";
  static const String ayarlar = "/Ayarlar";
  static const String kelimeEkle = "/KelimeEkle";
  static const String kelimelerim = "/Kelimelerim";
  static const String wordle = "/Wordle";
  static const String istatistik = "/Statistics";

  static Map<String, WidgetBuilder> routes = {
    "/HomePage": (context) => HomePage(),
    "/LoginPage": (context) => LoginPage(),
    "/SignupPage": (context) => SignupPage(),
    "/QuizPage": (context) => QuizPage(),
    "/ForgotPassword": (context) => ForgotPassword(),
    "/Ayarlar": (context) => AyarlarPage(),
    "/KelimeEkle": (context) => KelimeEkle(),
    "/Kelimelerim": (context) => Kelimelerim(),
    "/Wordle": (context) => Wordle(),
    "/Statistics": (contect) => StatisticsPage(),
  };
}
