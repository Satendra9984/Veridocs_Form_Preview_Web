import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_provider/form_provider.dart';
import '../app_utils/app_constants.dart';

class DropdownMenu extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const DropdownMenu({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  late final List<dynamic> items;
  dynamic currentValue;

  @override
  void initState() {
    _initializeOptionList();
    initializeData();
    super.initState();
  }

  void _initializeOptionList() {
    items = [
      {
        'id': '-1',
        'value': 'Choose',
      }
    ];
    if (widget.widgetJson.containsKey('options')) {
      items.addAll(widget.widgetJson['options']);
    }
    currentValue = items[0];
  }

  void initializeData() {
    dynamic init =
        widget.provider.getResult['${widget.pageId},${widget.fieldId}'];
    if (init != null) {
      for (var item in items) {
        if (init['value'] == item['value'] && init['id'] == item['id']) {
          currentValue = item;
        }
      }

      debugPrint('initial dropdown value --> $init\n');
    }
    debugPrint('optionList --> $items\n');
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
      decoration: containerElevationDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getLabel(),

          const SizedBox(
            height: 10,
          ),
          FormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: currentValue,
            validator: (currentOption) {
              if (widget.widgetJson.containsKey('required') &&
                  widget.widgetJson['required'] == true &&
                  currentValue['id'] == '-1') {
                return 'Please choose a option';
              }
              return null;
            },
            builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2.5),
                    decoration: containerElevationDecoration.copyWith(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: const Offset(0.0, 0.5), //(x,y)
                          blurRadius: 0.0,
                        ),
                      ],
                    ),
                    child: DropdownButton<dynamic>(
                      hint: Text(
                        'Choose',
                        style: kHintTextStyle,
                      ),
                      value: currentValue,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: CupertinoColors.black,
                      ),
                      items: items.map(
                        (option) {
                          var optionMap = option;
                          var value = optionMap['value'];

                          // debugPrint(
                          //     'value data type --> ${value.runtimeType}');
                          if (value.toString().isEmpty) {
                            value = 'choose';
                          }

                          // debugPrint(option.toString());
                          return DropdownMenuItem(
                            value: option,
                            onTap: () => setState(() {
                              debugPrint('value selected --> $option');
                            }),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 14,
                                color: optionMap['id'] == '-1'
                                    ? Colors.grey.shade600
                                    : Colors.black,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          currentValue = value;
                        });
                        // widget.provider.updateData(
                        //     pageId: widget.pageId,
                        //     fieldId: widget.fieldId,
                        //     value: value);
                        formState.didChange(currentValue);
                      },
                      isExpanded: true,
                    ),
                  ),
                  if (formState.hasError)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
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
          // TextFormField(
          //   controller: _controller,
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   validator: (currentOption) {
          //     if (widget.widgetJson.containsKey('required') &&
          //         currentValue['id'] == '-1') {
          //       return 'Please choose a option';
          //     }
          //     return null;
          //   },
          //   scrollPadding: const EdgeInsets.all(-5),
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //     focusedBorder: InputBorder.none,
          //     enabledBorder: InputBorder.none,
          //     errorBorder: InputBorder.none,
          //     disabledBorder: InputBorder.none,
          //     isCollapsed: true,
          //     isDense: true,
          //     contentPadding: EdgeInsets.all(-5),
          //   ),
          // )
        ],
      ),
    );
  }
}
