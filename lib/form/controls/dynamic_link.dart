import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/views/form_view/form_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../model/doctype_response.dart';
import '../../app/app.locator.dart';
import '../../services/api/api.dart';

class DynamicLink extends StatefulWidget {
  final DoctypeField doctypeField;
  final Map doc;
  final OnControlChanged? onControlChanged;

  final key;
  final bool showInputBorder;
  final Function? onSuggestionSelected;
  final Function? noItemsFoundBuilder;
  final Widget? prefixIcon;
  final Widget Function(BuildContext, Object)? itemBuilder;
  final AxisDirection direction;
  final TextEditingController? controller;

  DynamicLink({
    this.key,
    required this.doctypeField,
    this.onControlChanged,
    required this.doc,
    this.prefixIcon,
    this.onSuggestionSelected,
    this.noItemsFoundBuilder,
    this.showInputBorder = false,
    this.itemBuilder,
    this.controller,
    this.direction = AxisDirection.down,
  });

  @override
  _DynamicLinkState createState() => _DynamicLinkState();
}

class _DynamicLinkState extends State<DynamicLink> {
  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];
    late bool enabled;

    if (widget.doctypeField.reqd == 1) {
      validators.add(FormBuilderValidators.required());
    }

    if (widget.doctypeField.readOnly == 1 ||
        (widget.doc != null && widget.doctypeField.setOnlyOnce == 1)) {
      enabled = false;
    } else {
      enabled = true;
    }

    if (widget.doc[widget.doctypeField.fieldname] != null &&
        widget.doctypeField.setOnlyOnce == 1) {
      enabled = false;
    } else {
      enabled = true;
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: FormBuilderTypeAhead(
          key: widget.key,
          enabled: enabled,
          onChanged: (val) {
            // if (widget.onControlChanged != null) {
            //   widget.onControlChanged!(
            //     FieldValue(
            //       field: widget.doctypeField,
            //       value: val,
            //     ),
            //   );
            // }
          },
          controller: widget.controller,
          initialValue: widget.doc[widget.doctypeField.fieldname],
          direction: AxisDirection.up,
          onSuggestionSelected: (item) {
            if (widget.onSuggestionSelected != null) {
              if (item is String) {
                widget.onSuggestionSelected!(item);
              } else if (item is Map) {
                widget.onSuggestionSelected!(item["value"]);
              }
            }
          },
          validator: FormBuilderValidators.compose(validators),
          decoration: Palette.formFieldDecoration(
            label: widget.doctypeField.label,
            suffixIcon: widget.doc[widget.doctypeField.fieldname] != null &&
                    widget.doc[widget.doctypeField.fieldname] != ""
                ? IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: FormView(
                            doctype: widget.doc[widget.doctypeField.options],
                            name: widget.doc[widget.doctypeField.fieldname]),
                      );
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

            var response = await locator<Api>().searchLink(
              doctype: widget.doc[widget.doctypeField.options],
              txt: lowercaseQuery,
            );

            return response["results"];
          }),
    );
  }
}
