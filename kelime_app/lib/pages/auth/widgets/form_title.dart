import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';

class FormTitle extends StatelessWidget {
  final String text;
  const FormTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 18),
        child: Text(
          text,
          style: TextStyle(color: AppColors.formTitle, fontSize: 16),
        ),
      ),
    );
  }
}
