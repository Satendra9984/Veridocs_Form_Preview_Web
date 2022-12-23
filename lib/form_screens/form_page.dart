import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_provider/form_provider.dart';
import '../app_utils/app_constants.dart';
import '../form_widgets/date_time.dart';
import '../form_widgets/dropdown.dart';
import '../form_widgets/form_aadhar_number_input.dart';
import '../form_widgets/form_email_input.dart';
import '../form_widgets/form_file_input.dart';
import '../form_widgets/form_pan_number_input.dart';
import '../form_widgets/form_text_input.dart';
import '../form_widgets/image_input.dart';
import '../form_widgets/location_input.dart';
import '../form_widgets/phone_number_input.dart';
import '../form_widgets/table.dart';
import '../form_widgets/text.dart';
import '../form_widgets/toggle_button.dart';

class FormPage extends StatefulWidget {
  var singlePageData;
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final FormProvider provider;

  FormPage({
    Key? key,
    required this.currentPage,
    required this.singlePageData,
    required this.pageController,
    required this.totalPages,
    required this.provider,
  }) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late var _pageData;

  late FormProvider provider;

  @override
  void initState() {
    super.initState();
    debugPrint('form page has been initialized page ${widget.currentPage}');
    provider = widget.provider;
    _initializePageData();
  }

  @override
  void dispose() {
    debugPrint('form page has been disposed page ${widget.currentPage}');
    super.dispose();
  }

  void _initializePageData() {
    _pageData = widget.singlePageData['fields'] ?? [];
  }

  int _getLength() {
    List<dynamic> wid = _pageData as List<dynamic>;
    return wid.length;
  }

  double _getSideMargin() {
    double width = MediaQuery.of(context).size.width;
    // debugPrint('Screen size-> $width content size-> ${width * 0.4}');
    double widgetSize = width * 4;
    if (widgetSize < 450.0) {
      return 0;
    }
    return width * 0.3;
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      // backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Customer Verification Form'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: _getSideMargin()),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(5.234589786),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _getLength(),
                          itemBuilder: (context, index) {
                            var field = _pageData;
                            if (field[index] != null &&
                                field[index]['widget'] == 'text') {
                              return TextTitle(
                                widgetData: field[index],
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'text-input') {
                              return FormTextInput(
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                widgetJson: field[index],
                                provider: provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'address') {
                              return GetUserLocation(
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                widgetJson: field[index],
                                provider: provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'toggle-input') {
                              return ToggleButton(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'dropdown') {
                              return DropdownMenu(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'date-time') {
                              return DateTimePicker(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'file') {
                              return FormFileInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'image') {
                              return FormImageInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'table') {
                              return FormTableInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'email') {
                              return FormEmailTextInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'phone') {
                              return FormPhoneNumberInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'pan') {
                              return FormPanNumberInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else if (field[index] != null &&
                                field[index]['widget'] == 'aadhar') {
                              return FormAadharNumberInput(
                                widgetJson: field[index],
                                pageId: widget.currentPage.toString(),
                                fieldId: index.toString(),
                                provider: widget.provider,
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(top: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration:
                                    containerElevationDecoration.copyWith(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(0.0, 0.5), //(x,y)
                                      blurRadius: 0.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.error_outline,
                                      color: CupertinoColors.systemRed,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Invalid Form Field',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: CupertinoColors.systemRed,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.currentPage > 0
                                ? ElevatedButton(
                                    onPressed: () {
                                      widget.pageController
                                          .jumpToPage(widget.currentPage - 1);
                                    },
                                    child: const Center(
                                      child: Text('Back'),
                                    ),
                                  )
                                : const Text(''),
                            const SizedBox(width: 15),
                            widget.currentPage < widget.totalPages - 1
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await _validateForm(context);
                                    },
                                    child: const Center(
                                      child: Text('Next'),
                                    ),
                                  )
                                : const Text(''),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateForm(BuildContext cont) async {
    // if (_formKey.currentState!.validate()) {
    //   ScaffoldMessenger.of(cont).showSnackBar(
    //     const SnackBar(
    //       content: Text('Submitting data'),
    //     ),
    //   );
    widget.pageController.jumpToPage(widget.currentPage + 1);
    // }
    // await widget.provider.saveDraftData();
  }

  // @override
  // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
