import 'dart:io';

import 'package:flutter/cupertino.dart';
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
        text: '$label',
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
    String? data;
    debugPrint('pageId-> ${widget.pageId}, fieldId-> ${widget.fieldId}');
    if (widget.widgetJson['widget'] == 'dropdown') {
      data = widget
          .provider.getResult['${widget.pageId},${widget.fieldId}']['value']
          .toString();
    } else {
      data = widget.provider.getResult['${widget.pageId},${widget.fieldId}']
          .toString();
    }

    _textEditingController.text = data ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(),
      child: FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: _textEditingController,
        validator: (val) {
          String? value = _textEditingController.text;
          if (widget.widgetJson.containsKey('required') &&
              widget.widgetJson['required'] == true &&
              (value.isEmpty)) {
            return 'Please write some text';
          }
          return null;
        },
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getLabel(),
              const SizedBox(
                height: 10,
              ),
              Text(
                _textEditingController.text.toString(),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              if (formState.hasError)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: CupertinoColors.systemRed,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formState.errorText!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemRed,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
