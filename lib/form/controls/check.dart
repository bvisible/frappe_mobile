import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/doctype_response.dart';

import '../../config/frappe_palette.dart';
import '../../config/palette.dart';


class Check extends StatelessWidget {
  final DoctypeField doctypeField;
  final OnControlChanged? onControlChanged;
  final Key? key;
  final Map? doc;
  final Function? onChanged;

  const Check({
    required this.doctypeField,
    this.onChanged,
    this.onControlChanged,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    if (doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    return FormBuilderCheckbox(
      name: doctypeField.fieldname,
      key: key,
      enabled:
          doctypeField.readOnly != null ? doctypeField.readOnly == 0 : true,
      valueTransformer: (val) {
        return val == true ? 1 : 0;
      },
      activeColor: FrappePalette.blue,
      initialValue: doc != null ? doc![doctypeField.fieldname] == 1 : null,
      onChanged: (val) {
        if (onControlChanged != null) {
          onControlChanged!(
            FieldValue(
              field: doctypeField,
              value: val == true ? 1 : 0,
            ),
          );
        }
      },
      title: Text(
        doctypeField.label!,
        style: TextStyle(
          color: FrappePalette.grey[700],
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
        filled: false,
        field: "check",
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
