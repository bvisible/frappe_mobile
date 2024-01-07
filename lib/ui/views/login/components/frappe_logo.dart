import 'package:flutter/material.dart';

class FrappeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/frappe_icon.jpg'),
      width: 60,
      height: 60,
    );
  }
}