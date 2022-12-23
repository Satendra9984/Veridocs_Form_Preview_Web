import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app_provider/form_provider.dart';
import '../app_utils/app_constants.dart';

class ToggleButton extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  final String? rowId;
  final String? colId;
  const ToggleButton(
      {Key? key,
      required this.pageId,
      required this.fieldId,
      required this.provider,
      required this.widgetJson,
      this.rowId,
      this.colId})
      : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool? status;
  int tapped = 0;
  Icon _currentIcon = const Icon(
    Icons.check_box_outline_blank,
    size: 28,
  );

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    if (widget.rowId == null) {
      status = widget.provider.getResult['${widget.pageId},${widget.fieldId}'];
    } else {
      status = widget.provider.getResult[
          '${widget.pageId},${widget.fieldId},${widget.rowId},${widget.colId}'];
    }
    if (status == null) {
      _currentIcon = const Icon(
        Icons.check_box_outline_blank,
        size: 28,
      );
    } else if (status == true) {
      _currentIcon = const Icon(
        FontAwesomeIcons.check,
        color: CupertinoColors.systemGreen,
        size: 28,
      );
    } else {
      _currentIcon = const Icon(
        FontAwesomeIcons.xmark,
        color: CupertinoColors.destructiveRed,
        size: 28,
      );
    }
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
          // TextSpan(
          //   text: ' *',
          //   style: TextStyle(
          //     color: Colors.red,
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: widget.rowId == null ? containerElevationDecoration : null,
      child: FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: status,
        validator: (value) {
          if (widget.widgetJson.containsKey('required') &&
              widget.widgetJson['required'] == true &&
              status == null) {
            return 'Please select a value';
          }
          return null;
        },
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getLabel(),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon: _currentIcon,
                    onPressed: () {
                      _setCheckIcon();
                      // widget.provider.updateData(
                      //   pageId: widget.pageId,
                      //   fieldId: widget.fieldId,
                      //   rowId: widget.rowId,
                      //   columnId: widget.colId,
                      //   value: status,
                      // );
                      formState.didChange(status);
                    },
                  ),
                ],
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

  void _setCheckIcon() {
    tapped = (++tapped) % 3;
    if (tapped == 0) {
      setState(() {
        status = null;
        _currentIcon = const Icon(
          Icons.check_box_outline_blank,
          size: 28,
        );
      });
    } else if (tapped == 1) {
      setState(() {
        status = true;
        _currentIcon = const Icon(
          FontAwesomeIcons.check,
          color: CupertinoColors.systemGreen,
          size: 28,
        );
      });
    } else {
      setState(() {
        status = false;
        _currentIcon = const Icon(
          FontAwesomeIcons.xmark,
          color: CupertinoColors.destructiveRed,
          size: 28,
        );
      });
    }
    debugPrint('status -->> $status');
  }
}
