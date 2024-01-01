import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/views/form_view/form_view.dart';
import 'package:frappe_app/widgets/form_builder_typeahead.dart';

import '../../model/doctype_response.dart';
import '../../app/locator.dart';
import '../../services/api/api.dart';

import '../../utils/helpers.dart';
import '../../model/offline_storage.dart';

class LinkField extends StatefulWidget {
  final DoctypeField doctypeField;
  final Map? doc;
  final OnControlChanged? onControlChanged;

  final key;
  final bool showInputBorder;
  final Function? onSuggestionSelected;
  final Function? noItemsFoundBuilder;
  final Widget? prefixIcon;
  final ItemBuilder? itemBuilder;
  final AxisDirection direction;
  final TextEditingController? controller;

  LinkField({
    this.key,
    required this.doctypeField,
    this.onControlChanged,
    this.doc,
    this.prefixIcon,
    this.onSuggestionSelected,
    this.noItemsFoundBuilder,
    this.showInputBorder = false,
    this.itemBuilder,
    this.controller,
    this.direction = AxisDirection.down,
  });

  @override
  _LinkFieldState createState() => _LinkFieldState();
}

class _LinkFieldState extends State<LinkField> {
  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];
    late bool enabled;

    if (widget.doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    // if (widget.doctypeField.readOnly == 1 ||
    //     (widget.doc != null && widget.doctypeField.setOnlyOnce == 1)) {
    //   enabled = false;
    // } else {
    //   enabled = true;
    // }

    if (widget.doc != null && widget.doctypeField.setOnlyOnce == 1) {
      enabled = false;
    } else {
      enabled = true;
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: FormBuilderTypeAhead(
        key: widget.key,
        enabled: enabled,
        controller: widget.controller,
        initialValue: widget.doc != null
            ? widget.doc![widget.doctypeField.fieldname]
            : null,
        direction: AxisDirection.up,
        onSuggestionSelected: (item) {
          var val = item is String
              ? item
              : item is Map
                  ? item["value"]
                  : null;
          if (widget.onSuggestionSelected != null) {
            widget.onSuggestionSelected!(val);
          }
          if (widget.onControlChanged != null) {
            widget.onControlChanged!(
              FieldValue(
                field: widget.doctypeField,
                value: val,
              ),
            );
          }
        },
        validator: FormBuilderValidators.compose(validators),
        decoration: Palette.formFieldDecoration(
          label: widget.doctypeField.label,
          suffixIcon: widget.doc?[widget.doctypeField.fieldname] != null &&
                  widget.doc?[widget.doctypeField.fieldname] != ""
              ? IconButton(
                  onPressed: () {
                    // pushNewScreen(
                    //   context,
                    //   screen: FormView(
                    //       doctype: widget.doctypeField.options,
                    //       name: widget.doc![widget.doctypeField.fieldname]),
                    // );
                  },
                  icon: FrappeIcon(
                    FrappeIcons.arrow_right_2,
                    size: 14,
                  ),
                )
              : null,
        ),
        selectionToTextTransformer: (item) {
          if (item != null) {
            if (item is Map) {
              return item["value"];
            }
          }
          return item.toString();
        },
        name: widget.doctypeField.fieldname,
        itemBuilder: widget.itemBuilder ??
            (context, item) {
              if (item is Map) {
                return ListTile(
                  title: Text(
                    item["value"],
                  ),
                  subtitle: item["description"] != null
                      ? Text(
                          item["description"],
                        )
                      : null,
                );
              } else {
                return ListTile(
                  title: Text(item.toString()),
                );
              }
            },
        suggestionsCallback: (query) async {
          var lowercaseQuery = query.toLowerCase();
          var isOnline = await verifyOnline();
          if (!isOnline) {
            var linkFull = await OfflineStorage.getItem(
                '${widget.doctypeField.options}LinkFull');
            linkFull = linkFull["data"];

            if (linkFull != null) {
              return linkFull["results"].where(
                (link) {
                  return (link["value"] as String)
                      .toLowerCase()
                      .contains(lowercaseQuery);
                },
              ).toList();
            } else {
              var queryLink = await OfflineStorage.getItem(
                  '$lowercaseQuery${widget.doctypeField.options}Link');
              queryLink = queryLink["data"];

              if (queryLink != null) {
                return queryLink["results"];
              } else {
                return [];
              }
            }
          } else {
            var response = await locator<Api>().searchLink(
              doctype: widget.doctypeField.options,
              txt: lowercaseQuery,
            );

            return response["results"];
          }
        },
      ),
    );
  }
}
