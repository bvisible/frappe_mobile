import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/views/home_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model/config.dart';
import 'views/login/login_view.dart';

class FrappeApp extends StatefulWidget {
  @override
  _FrappeAppState createState() => _FrappeAppState();
}

class _FrappeAppState extends State<FrappeApp> {
  bool _isLoggedIn = false;
  bool _isLoaded = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() {
    setState(() {
      _isLoggedIn = Config().isLoggedIn;
    });

    _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: _isLoaded
            ? _isLoggedIn
                ? HomeView()
                : Login()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
