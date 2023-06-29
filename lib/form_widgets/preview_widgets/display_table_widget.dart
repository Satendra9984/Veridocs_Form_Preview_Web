import 'package:flutter/material.dart';
import 'package:veridocs_web_form_preview/form_widgets/preview_widgets/preview_display_table_text.dart';
import '../../app_provider/form_provider.dart';
import '../../form_screens/form_constants.dart';

class PreviewFormTableInout extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const PreviewFormTableInout({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<PreviewFormTableInout> createState() => _PreviewFormTableInoutState();
}

class _PreviewFormTableInoutState extends State<PreviewFormTableInout> {
  late List<dynamic> _columnLabels;
  late List<dynamic> _rowLabels;

  @override
  void initState() {
    super.initState();
    // debugPrint('table: ${prettyJson(widget.widgetJson)}');

    _columnLabels = widget.widgetJson['columns'] ?? [];
    _rowLabels = widget.widgetJson['rows'] ?? [];

    dynamic response = widget.provider.getResult;
    // debugPrint('response table: ${prettyJson(response)}');

    // debugPrint('pageIdtable: ${widget.pageId}, filedid: ${widget.fieldId}');
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: label,
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
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // decoration: containerElevationDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// For the main heading/title
          Container(
            margin: const EdgeInsets.only(left: 15, top: 25),
            child: _getLabel(),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            /// For each column_label
            children: _rowLabels.map(
              (row) {
                // debugPrint('Col: ${prettyJson(col)}');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    row != ''
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_rowLabels.indexOf(row) + 1}) ${row['label']}',
                                style: const TextStyle(
                                  fontSize: kLabelFontSize - 1,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(
                                width: 5,
                                height: 8,
                              ),
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _columnLabels.map<Widget>(
                          (col) {
                            if (col['widget'] == '') {
                              col['widget'] = null;
                            }
                            String type = (col['widget'] ?? '');
                            if (type == 'toggle-input' ||
                                type == 'date-time' ||
                                type == 'address' ||
                                type == 'text-input') {
                              return FormTablePreviewText(
                                rowId: row['id'].toString(),
                                colId: col['id'].toString(),
                                pageId: widget.pageId,
                                fieldId: widget.fieldId,
                                provider: widget.provider,
                                widgetJson: col,
                              );
                            } else {
                              return FormTablePreviewText(
                                widgetJson: {
                                  "id": row['id'],
                                  "label": row['label'],
                                  "required": false,
                                  "widget": row['widget'],
                                },
                                rowId: row['id'].toString(),
                                colId: col['id'].toString(),
                                pageId: widget.pageId,
                                fieldId: widget.fieldId,
                                provider: widget.provider,
                              );
                            }
                          },
                        ).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      indent: 3,
                      endIndent: 3,
                      thickness: 1,
                    ),
                    const SizedBox(height: 5),
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
