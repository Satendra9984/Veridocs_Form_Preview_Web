import 'package:flutter/material.dart';
import '../app_provider/form_provider.dart';
import '../form_widgets/form_text_input.dart';
import '../form_widgets/location_input.dart';
import '../form_widgets/signature.dart';

class FormSubmitPage extends StatefulWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final FormProvider provider;
  const FormSubmitPage({
    Key? key,
    required this.currentPage,
    required this.pageController,
    required this.totalPages,
    required this.provider,
  }) : super(key: key);

  @override
  State<FormSubmitPage> createState() => _FormSubmitPageState();
}

class _FormSubmitPageState extends State<FormSubmitPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Submit Form'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: _getSideMargin()),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormSignature(
                  pageId: widget.currentPage.toString(),
                  fieldId: '0',
                  provider: widget.provider,
                ),
                const SizedBox(
                  height: 10,
                ),
                FormTextInput(
                  widgetJson: const {
                    "id": 2,
                    "label": "Final Report",
                    "length": 300,
                    "required": true,
                    "widget": "text-input",
                    "multi_line": true,
                  },
                  pageId: widget.currentPage.toString(),
                  fieldId: '1',
                  provider: widget.provider,
                ),
                GetUserLocation(
                  widgetJson: const {
                    'id': 8,
                    'label': 'user location',
                    'widget': 'geolocation',
                    'required': true,
                  },
                  pageId: widget.currentPage.toString(),
                  fieldId: '2',
                  provider: widget.provider,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.pageController
                            .jumpToPage(widget.currentPage - 1);
                      },
                      child: const Center(
                        child: Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () async {
                        await _validateSubmitPage();
                      },
                      child: const Center(
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateSubmitPage() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submitting form'),
        ),
      );
      // await widget.provider.saveDraftData();
      Navigator.pop(context);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
