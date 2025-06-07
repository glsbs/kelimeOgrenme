import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelime_app/constants/colors.dart';

class BaslikYazisi extends StatelessWidget {
  final String title;
  const BaslikYazisi({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            title,
            style: GoogleFonts.rubik(fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ),

        Divider(
          endIndent: 60,
          indent: 15,
          thickness: 4,
          color: AppColors.dividerRengi,
        ),
      ],
    );
  }
}
