import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_provider/form_provider.dart';

class FormTableTextInput extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  final String colId, rowId;
  const FormTableTextInput({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
    required this.colId,
    required this.rowId,
  }) : super(key: key);

  @override
  State<FormTableTextInput> createState() => _FormTableTextInputState();
}

class _FormTableTextInputState extends State<FormTableTextInput> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    String? data = widget.provider.getResult[
        '${widget.pageId},${widget.fieldId},${widget.rowId},${widget.colId}'];

    if (data != null) {
      _textEditingController.text = data;
    }
    super.initState();
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
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: _textEditingController,
        validator: (val) {
          if (widget.widgetJson['required'] == true &&
              _textEditingController.text.isEmpty) {
            return 'Please enter a value';
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
              TextField(
                controller: _textEditingController,
                onChanged: (text) {
                  // widget.provider.updateData(
                  //   pageId: widget.pageId,
                  //   fieldId: widget.fieldId,
                  //   rowId: widget.rowId,
                  //   columnId: widget.colId,
                  //   value: _textEditingController.text.toString(),
                  // );
                  formState.didChange(_textEditingController);
                },
                minLines: 1,
                maxLines: widget.widgetJson['multi_line'] ?? false ? 7 : 1,
                maxLength: widget.widgetJson['length'],
                // keyboardType: _getKeyboardType(),
                decoration: const InputDecoration(
                  hintText: 'Your Answer',
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  isDense: true, // Added this
                  // contentPadding: EdgeInsets.all(0),
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
