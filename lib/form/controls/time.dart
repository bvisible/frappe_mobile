import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/model/doctype_response.dart';

class Time extends StatelessWidget {
  final DoctypeField doctypeField;
  final Key? key;
  final Map? doc;

  const Time({
    required this.doctypeField,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    if (doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    var initialValue;

    if (doc != null) {
      var value = doc![doctypeField.fieldname];

      if (value != null) {
        if ((value as String).contains("T")) {
          value = doc![doctypeField.fieldname].split("T")[1];
        }
        initialValue = DateFormat.Hms().parse(
          value,
        );
      }
    }

    return FormBuilderDateTimePicker(
      key: key,
      initialValue: initialValue,
      inputType: InputType.time,
      valueTransformer: (val) {
        return val?.toIso8601String();
      },
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
