import 'package:flutter/material.dart';
import '../../app_provider/form_provider.dart';
import '../../form_screens/form_constants.dart';

class FormTextResultDisplay extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const FormTextResultDisplay({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<FormTextResultDisplay> createState() => _FormTextResultDisplayState();
}

class _FormTextResultDisplayState extends State<FormTextResultDisplay> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    setResult();
    super.initState();
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: kLabelFontSize - 1,
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
                fontSize: kLabelFontSize - 2,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  void setResult() {
    dynamic data;
    if (widget.widgetJson['widget'] == 'dropdown') {
      data = widget
              .provider.getResult['${widget.pageId},${widget.fieldId}']['value']
              .toString() ??
          '--';
    } else {
      data = widget.provider.getResult['${widget.pageId},${widget.fieldId}'];

      if (data == null) {
        data = '----';
      } else if (data.runtimeType == bool) {
        if (data) {
          data = 'Yes';
        } else {
          data = 'No';
        }
      }
    }
    _textEditingController.text = data ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getLabel(),
          const SizedBox(height: 10),
          Text(
            _textEditingController.text.toString(),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
