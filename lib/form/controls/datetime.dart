import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../config/palette.dart';
import '../../model/doctype_response.dart';
import '../../utils/helpers.dart';

class DatetimeField extends StatelessWidget {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const DatetimeField({
    required this.doctypeField,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? value;

    if (doc != null) {
      if (doc![doctypeField.fieldname] == "Now") {
        value = DateTime.now();
      } else {
        value = parseDate(doc![doctypeField.fieldname]);
      }
    }
    List<String? Function(dynamic)> validators = [];

    if (doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    return FormBuilderDateTimePicker(
      key: key,
      valueTransformer: (val) {
        return val?.toIso8601String();
      },
      resetIcon: Icon(Icons.close),
      initialValue: value,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
