import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';

class GreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const GreenButton({required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 343,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.girisButonRengi,
        ),
        height: 49,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
