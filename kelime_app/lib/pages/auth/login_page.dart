import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:kelime_app/pages/auth/widgets/baslik_yazisi.dart';
import 'package:kelime_app/pages/services/auth_services.dart';
import 'widgets/custom_input_decoration.dart';
import 'widgets/dikey_bosluk.dart';
import 'widgets/form_title.dart';
import 'widgets/green_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _sifreController = TextEditingController();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _sifreController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * .40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/sign_in.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              BaslikYazisi(title: "Giriş Yap"),
              DikeyBosluk(),
              FormTitle("Email"),
              TextFormField(
                controller: _emailController,

                decoration: customInputDecoration(
                  Icons.mail_outline_rounded,
                  "demo@email.com",
                ),
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
              ),
              DikeyBosluk(),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed:
                      () => Navigator.pushNamed(context, "/ForgotPassword"),

                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      color: Color(0xff1BBC21),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ), //yeşil renk
              DikeyBosluk(),
              Center(
                child: GreenButton(
                  text: "Giriş Yap",
                  onTap: () async {
                    try {
                      await AuthService().signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _sifreController.text.trim(),
                      );

                      // Giriş başarılıysa yönlendir
                      Navigator.pushReplacementNamed(context, "/HomePage");
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Giriş başarısız: $e")),
                      );
                    }
                  },
                ),
              ),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hesabın Yok Mu?", style: TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(context, "/SignupPage"),
                      child: Text(
                        "Kaydol",
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
    );
  }
}
