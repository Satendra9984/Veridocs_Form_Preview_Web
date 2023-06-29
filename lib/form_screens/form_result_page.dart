import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_provider/form_provider.dart';
import '../app_utils/app_functions.dart';
import '../form_widgets/preview_widgets/display_files.dart';
import '../form_widgets/preview_widgets/display_images.dart';
import '../form_widgets/preview_widgets/display_table_widget.dart';
import '../form_widgets/preview_widgets/form_result_display_text.dart';
import '../form_widgets/preview_widgets/text.dart';
import 'form_constants.dart';

class FormResultPreviewPage extends StatefulWidget {
  final FormProvider provider;
  final String agencyId;
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final bool showNavigationOptions;
  const FormResultPreviewPage({
    Key? key,
    required this.provider,
    required this.agencyId,
    required this.currentPage,
    required this.pageController,
    required this.totalPages,
    this.showNavigationOptions = true,
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: const BackButton(
          color: Colors.black, // Change the color here
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Form Preview',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(width: 5),
            Text(
              widget.provider.assignmentId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          width: size.width > 1000 ? 1000 : size.width,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              if (_pageData.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pageData.length,
                  itemBuilder: (ctx, index) {
                    debugPrint(index.toString());
                    Map<String, dynamic> singlePageData =
                        Map<String, dynamic>.from(_pageData[index]);

                    List<dynamic> fieldData = singlePageData['fields'] ?? [];

                    try {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.black.withOpacity(0.750),
                                  size: 18,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '${_pageData[index]['name']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.circle, color: Colors.white),
                              ],
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
                                    field[fieldIndex]['widget'] ==
                                        'text-input') {
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
                                    field[fieldIndex]['widget'] ==
                                        'date-time') {
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
                                    field[fieldIndex]['widget'] == 'number') {
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
                                } else if (field[fieldIndex] != null &&
                                    field[fieldIndex]['widget'] == 'file') {
                                  return FormFileDisplay(
                                    widgetJson: field[fieldIndex],
                                    pageId: index.toString(),
                                    fieldId: fieldIndex.toString(),
                                    provider: widget.provider,
                                  );
                                } else if (field[fieldIndex] != null &&
                                        field[fieldIndex]['widget'] ==
                                            'image' ||
                                    field[fieldIndex]['widget'] ==
                                        'geotag_image') {
                                  return FormImagePreviewDisplay(
                                    widgetJson: field[fieldIndex],
                                    pageId: index.toString(),
                                    fieldId: fieldIndex.toString(),
                                    provider: widget.provider,
                                  );
                                } else if (field[fieldIndex] != null &&
                                    field[fieldIndex]['widget'] == 'table') {
                                  return PreviewFormTableInout(
                                    widgetJson: field[fieldIndex],
                                    pageId: index.toString(),
                                    fieldId: fieldIndex.toString(),
                                    provider: widget.provider,
                                  );
                                } else if (field[fieldIndex] != null &&
                                    field[fieldIndex]['widget'] ==
                                        'signature') {
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
                                        kContainerElevationDecoration.copyWith(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade500,
                                          offset:
                                              const Offset(0.0, 0.5), //(x,y)
                                          blurRadius: 0.0,
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      children: [
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
                    } catch (e) {
                      debugPrint(e.toString());
                      debugPrint(index.toString());
                      debugPrint(prettyJson(fieldData[index]));
                      return Column(
                        children: [
                          Text('$e'),
                        ],
                      );
                    }
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
