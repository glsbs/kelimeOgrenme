import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:kelime_app/pages/auth/widgets/green_button.dart';

class TestGiris extends StatelessWidget {
  const TestGiris({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.testeBasla,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                "QUIZ",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 35),
            Image.asset('assets/images/soru.png', width: 177, height: 161),
            SizedBox(height: 100),
            GreenButton(
              text: "Teste Başla",
              onTap: () => Navigator.pushNamed(context, "/QuizPage"),
            ),
          ],
        ),
      ),
    );
  }
}
