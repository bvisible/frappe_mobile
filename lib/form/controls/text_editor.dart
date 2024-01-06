import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/widgets/form_builder_text_editor.dart';

import '../../model/doctype_response.dart';

class TextEditor extends StatelessWidget {
  final DoctypeField doctypeField;
  final Key? key;
  final Map? doc;
  final Color? color;
  final bool fullHeight;

  const TextEditor({
    required this.doctypeField,
    this.key,
    this.doc,
    this.color,
    this.fullHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    if (doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    return FormBuilderTextEditor(
      key: key,
      fullHeight: fullHeight,
      initialValue: doc != null ? doc![doctypeField.fieldname] : null,
      name: doctypeField.fieldname,
      context: context,
      color: color,
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
