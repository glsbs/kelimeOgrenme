import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:kelime_app/pages/auth/widgets/baslik_yazisi.dart';
import 'package:kelime_app/pages/services/auth_services.dart';
import 'package:kelime_app/routes/app_routes.dart';
import 'widgets/custom_input_decoration.dart';
import 'widgets/dikey_bosluk.dart';
import 'widgets/form_title.dart';
import 'widgets/green_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _sifreController = TextEditingController();

  final _emailController = TextEditingController();

  final _sifreDogrulamaController = TextEditingController();
  final _isimController = TextEditingController();

  @override
  void dispose() {
    _sifreController.dispose();
    _emailController.dispose();
    _sifreDogrulamaController.dispose();
    _isimController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: height * .40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/signup.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                BaslikYazisi(title: "Kaydol"),
                DikeyBosluk(),
                FormTitle("Email"),
                TextFormField(
                  controller: _emailController,
                  decoration: customInputDecoration(
                    Icons.mail_outline_rounded,
                    "demo@email.com",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Girmediniz';
                    }
                    return null;
                  },
                ),
                FormTitle("Kullanıcı adı"),
                TextFormField(
                  controller: _isimController,
                  decoration: customInputDecoration(
                    Icons.person_outline,
                    "Adınızı girin",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kullanıcı ismi boş olamaz';
                    }
                    return null;
                  },
                ),

                DikeyBosluk(),
                FormTitle("Şifre"),

                TextFormField(
                  controller: _sifreController,
                  obscureText: true,
                  decoration: customInputDecoration(
                    Icons.key_rounded,
                    "Şifrenizi girin",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre Boş olamaz';
                    } else if (value.length < 6) {
                      return 'Şifre en az 6 karakter olamlı';
                    }
                    return null;
                  },
                ),
                DikeyBosluk(),
                FormTitle("Şifre"),
                TextFormField(
                  controller: _sifreDogrulamaController,
                  obscureText: true,
                  decoration: customInputDecoration(
                    Icons.key_rounded,
                    "Şifrenizi girin",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre Boş olamaz';
                    } else if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalı';
                    } else if (value != _sifreController.text) {
                      return 'Şifreler uyuşmuyor';
                    }
                    return null;
                  },
                ),

                DikeyBosluk(),
                Center(
                  child: GreenButton(
                    text: "Kaydol",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await AuthService().createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _sifreController.text.trim(),
                            userName: _isimController.text.trim(),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.home,
                          );
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                  ),
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hesabın Var Mı?", style: TextStyle(fontSize: 14)),
                      TextButton(
                        onPressed:
                            () => Navigator.pushNamed(context, "/LoginPage"),
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(
                            color: AppColors.gecisYazi,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
