import 'package:flutter/material.dart';

class DikeyBosluk extends StatelessWidget {
  final double height;
  const DikeyBosluk({this.height = 20, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
