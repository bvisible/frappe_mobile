import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/model/doctype_response.dart';

class ReadOnly extends StatelessWidget {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const ReadOnly({
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

    return FormBuilderTextField(
      key: key,
      readOnly: true,
      initialValue: doc != null ? doc![doctypeField.fieldname] : null,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
