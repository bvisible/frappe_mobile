import 'package:flutter/material.dart';

import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/utils/frappe_icon.dart';

import '../../model/doctype_response.dart';

typedef String SelectionToTextTransformer<T>(T selection);

class AutoComplete extends StatefulWidget {
  final DoctypeField doctypeField;
  final void Function(dynamic)? onControlChanged;

  final Map? doc;
  final void Function(dynamic)? onSuggestionSelected;
  final Widget? suffixIcon;
  final Key? key;
  final Widget Function(BuildContext, dynamic)? itemBuilder;
  final SelectionToTextTransformer? selectionToTextTransformer;
  final InputDecoration? inputDecoration;
  final TextEditingController? controller;

  AutoComplete({
    required this.doctypeField,
    this.onControlChanged,
    this.doc,
    this.controller,
    this.inputDecoration,
    this.suffixIcon,
    this.key,
    this.onSuggestionSelected,
    this.itemBuilder,
    this.selectionToTextTransformer,
  });

  @override
  _AutoCompleteState createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  TextEditingController? _typeAheadController;

  @override
  void initState() {
    _typeAheadController = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    if (widget.doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: FormBuilderTypeAhead(
        key: widget.key,
        controller: _typeAheadController,
        onSuggestionSelected: widget.onSuggestionSelected,
        // onChanged: (val) {
        //   if (widget.onControlChanged != null) {
        //     widget.onControlChanged!(
        //       FieldValue(
        //         field: widget.doctypeField,
        //         value: val,
        //       ),
        //     );
        //   }
        // },
        direction: AxisDirection.up,
        validator: FormBuilderValidators.compose(validators),
        decoration: widget.inputDecoration ??
            Palette.formFieldDecoration(
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.suffixIcon ??
                      FrappeIcon(
                        FrappeIcons.select,
                      ),
                ],
              ),
            ),
        selectionToTextTransformer: widget.selectionToTextTransformer ??
            (item) {
              return item.toString();
            },
        name: widget.doctypeField.fieldname,
        itemBuilder: widget.itemBuilder ??
            (context, item) {
              return ListTile(
                title: Text(
                  item.toString(),
                ),
              );
            },
        initialValue: widget.doc != null
            ? widget.doc![widget.doctypeField.fieldname]
            : null,
        suggestionsCallback: (query) {
          var lowercaseQuery = query.toLowerCase();
          List opts;
          if (widget.doctypeField.options is String) {
            opts = widget.doctypeField.options.split('\n');
          } else {
            opts = widget.doctypeField.options ?? [];
          }
          return opts
              .where(
                (option) => option.toLowerCase().contains(
                      lowercaseQuery,
                    ),
              )
              .toList();
        },
      ),
    );
  }
}
