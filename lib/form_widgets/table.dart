import 'package:flutter/material.dart';
import 'package:veridocs_web_form_preview/form_widgets/table_form_input.dart';
import 'package:veridocs_web_form_preview/form_widgets/toggle_button.dart';

import '../app_provider/form_provider.dart';
import '../app_utils/app_constants.dart';
import 'date_time.dart';
import 'location_input.dart';

class FormTableInput extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const FormTableInput({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<FormTableInput> createState() => _FormTableInputState();
}

class _FormTableInputState extends State<FormTableInput> {
  late List<dynamic> _columnLabels;
  late List<dynamic> _rowLabels;
  bool _isRequired = false;

  @override
  void initState() {
    super.initState();
    _columnLabels = widget.widgetJson['columns'];
    _rowLabels = widget.widgetJson['rows'];

    if (widget.widgetJson.containsKey('required') &&
        widget.widgetJson['required'] == true) {
      _isRequired = true;
    }

    // debugPrint(
    //     'rows --> ${_rowLabels.toString()}\n and type --> ${_columnLabels.runtimeType}');
    // debugPrint('columns --> ${_columnLabels.toString()}');
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: '$label',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        children: [
          if (widget.widgetJson.containsKey('required') &&
              widget.widgetJson['required'] == true)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerElevationDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// For the main heading/title
          Container(
            margin: const EdgeInsets.only(left: 15, top: 25),
            child: _getLabel(),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            /// For each row_label
            children: _columnLabels.map(
              (col) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    col != ''
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                col['label'].toString(),
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(
                                width: 5,
                                height: 0.5,
                              ),
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _rowLabels.map<Widget>(
                        (row) {
                          if (col['widget'] == '') {
                            col['widget'] = null;
                          }
                          String type = col['widget'] ?? (row['widget'] ?? '');
                          print(type);
                          if (type == 'toggle-button') {
                            return ToggleButton(
                              rowId: row['id'].toString(),
                              colId: col['id'].toString(),
                              pageId: '${widget.pageId},${widget.fieldId}',
                              fieldId: '${row['id']},${col['id']}',
                              provider: widget.provider,
                              widgetJson: row,
                            );
                          } else if (type == 'date-time') {
                            return DateTimePicker(
                              rowId: row['id'].toString(),
                              columnId: col['id'].toString(),
                              pageId: '${widget.pageId},${widget.fieldId}',
                              fieldId: '${row['id']},${col['id']}',
                              provider: widget.provider,
                              widgetJson: row,
                            );
                          } else if (type == 'address') {
                            return GetUserLocation(
                              rowId: row['id'].toString(),
                              colId: col['id'].toString(),
                              pageId: '${widget.pageId},${widget.fieldId}',
                              fieldId: '${row['id']},${col['id']}',
                              provider: widget.provider,
                              widgetJson: row,
                            );
                          } else {
                            return FormTableTextInput(
                              widgetJson: {
                                "id": row['id'],
                                "label": row['label'],
                                "required": _isRequired,
                                "widget": row['widget'],
                              },
                              pageId: widget.pageId,
                              fieldId: widget.fieldId,
                              provider: widget.provider,
                              colId: col['id'].toString(),
                              rowId: row['id'].toString(),
                            );
                          }
                        },
                      ).toList(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      indent: 3,
                      endIndent: 3,
                      thickness: 1,
                    )
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
