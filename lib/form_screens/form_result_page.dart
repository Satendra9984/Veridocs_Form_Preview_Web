import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_provider/form_provider.dart';
import '../app_utils/app_constants.dart';
import '../form_widgets/preview_widgets/display_files.dart';
import '../form_widgets/preview_widgets/display_images.dart';
import '../form_widgets/preview_widgets/form_result_display_text.dart';
import '../form_widgets/preview_widgets/text.dart';

class FormResultPreviewPage extends StatefulWidget {
  final FormProvider provider;
  final String agencyId;
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  const FormResultPreviewPage({
    Key? key,
    required this.provider,
    required this.agencyId,
    required this.currentPage,
    required this.pageController,
    required this.totalPages,
  }) : super(key: key);

  @override
  State<FormResultPreviewPage> createState() => _FormResultPreviewPageState();
}

class _FormResultPreviewPageState extends State<FormResultPreviewPage> {
  late List<dynamic> _pageData;

  late FormProvider provider;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
    debugPrint(provider.getResult.toString());
    _initializePageData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializePageData() {
    _pageData = widget.provider.getPages ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              const Text(
                "Form Preview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              if (_pageData.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pageData.length,
                  itemBuilder: (ctx, index) {
                    Map<String, dynamic> singlePageData =
                        Map<String, dynamic>.from(_pageData[index]);
                    List<dynamic> fieldData = singlePageData['fields'] ?? [];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Page ${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Divider(
                            thickness: 1.0,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (fieldData.isNotEmpty)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: fieldData.length,
                            itemBuilder: (context, fieldIndex) {
                              var field = fieldData;
                              if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'text') {
                                return TextTitle(
                                  widgetData: field[fieldIndex],
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'text-input') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'address') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] ==
                                      'toggle-input') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'dropdown') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'date-time') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'email') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'phone') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'pan') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'aadhar') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] ==
                                      'number-input') {
                                return FormTextResultDisplay(
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  widgetJson: field[fieldIndex],
                                  provider: widget.provider,
                                );
                              }
                              // else if (field[pageIndex] != null &&
                              //     field[pageIndex]['widget'] == 'table') {
                              //   return FormTableInput(
                              //     widgetJson: field[pageIndex],
                              //     pageId: widget.currentPage.toString(),
                              //     fieldId: pageIndex.toString(),
                              //     provider: widget.provider,
                              //   );
                              // }
                              else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'file') {
                                return FormFileDisplay(
                                  widgetJson: field[fieldIndex],
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'image') {
                                return FormImagePreviewDisplay(
                                  widgetJson: field[fieldIndex],
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  provider: widget.provider,
                                );
                              } else if (field[fieldIndex] != null &&
                                  field[fieldIndex]['widget'] == 'signature') {
                                return FormImagePreviewDisplay(
                                  widgetJson: field[fieldIndex],
                                  pageId: index.toString(),
                                  fieldId: fieldIndex.toString(),
                                  provider: widget.provider,
                                  isSignature: true,
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
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
