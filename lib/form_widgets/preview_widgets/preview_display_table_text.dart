import 'package:flutter/material.dart';
import '../../app_provider/form_provider.dart';
import '../../form_screens/form_constants.dart';

class FormTablePreviewText extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  final String colId, rowId;
  const FormTablePreviewText({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
    required this.colId,
    required this.rowId,
  }) : super(key: key);

  @override
  State<FormTablePreviewText> createState() => _FormTablePreviewTextState();
}

class _FormTablePreviewTextState extends State<FormTablePreviewText> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    String? data = widget
        .provider
        .getResult[
            '${widget.pageId},${widget.fieldId},${widget.rowId},${widget.colId}']
        .toString();

    _textEditingController.text = data ?? '--';

    super.initState();
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 14,
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
                fontSize: kLabelFontSize,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _getLabel()),
          Expanded(
            child: Text(
              _textEditingController.text.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
