import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/control.dart';
import 'package:frappe_app/model/doctype_response.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return buildDecoratedControl(
      control: Stack(
        alignment: Alignment.centerRight,
        children: [
          FormBuilderTextField(
            maxLines: 1,
            name: 'pwd',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            obscureText: _hidePassword,
            decoration: Palette.formFieldDecoration(
              label: "Password",
            ),
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
            ),
            child: Text(
              _hidePassword ? "Show" : "Hide",
              style: TextStyle(
                color: FrappePalette.grey[600],
              ),
            ),
            onPressed: () {
              setState(
                () {
                  _hidePassword = !_hidePassword;
                },
              );
            },
          )
        ],
      ),
      field: DoctypeField(fieldname: "password", label: "Password"),
    );
  }
}