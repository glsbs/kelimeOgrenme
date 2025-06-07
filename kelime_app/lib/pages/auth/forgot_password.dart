import 'package:flutter/material.dart';
import 'package:kelime_app/pages/auth/widgets/baslik_yazisi.dart';
import 'package:kelime_app/pages/auth/widgets/custom_input_decoration.dart';
import 'package:kelime_app/pages/auth/widgets/dikey_bosluk.dart';
import 'package:kelime_app/pages/auth/widgets/form_title.dart';
import 'package:kelime_app/pages/auth/widgets/green_button.dart';
import 'package:kelime_app/pages/services/auth_services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaslikYazisi(title: " E-mail Adresinizi Girin"),
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

                DikeyBosluk(),
                GreenButton(
                  text: "Kod Gönder",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await AuthService().resetPassword(
                          _emailController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("E-mail adresinize Kod gönderildi"),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Hate:$e")));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
