import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';

InputDecoration customInputDecoration(IconData iconData, String hintText) {
  return InputDecoration(
    prefixIcon: Icon(iconData, color: AppColors.iconRengi),
    hintText: hintText,
    hintStyle: TextStyle(color: AppColors.hintText),

    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.customInputcolor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.focusedBorder),
    ),
  );
}
