import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/model/doctype_response.dart';

import '../../config/palette.dart';

class Int extends StatelessWidget {
  final DoctypeField doctypeField;
  final void Function(String?)? onChanged;
  final Key? key;
  final Map? doc;

  const Int({
    required this.doctypeField,
    this.onChanged,
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
      onChanged: onChanged,
      initialValue: doc != null
          ? doc![doctypeField.fieldname] != null
              ? doc![doctypeField.fieldname].toString()
              : null
          : null,
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
