import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_provider/form_provider.dart';
import '../app_services/database/firestore_services.dart';
import 'form_result_page.dart';

class FormHomePage extends StatefulWidget {
  static String FormHomePageRouteName = '/form_home_page';
  final String caseId;
  const FormHomePage({
    required this.caseId,
    Key? key,
  }) : super(key: key);

  @override
  State<FormHomePage> createState() => _FormHomePageState();
}

class _FormHomePageState extends State<FormHomePage> {
  late FormProvider _formProvider;
  late PageController _pageController;

  @override
  void initState() {
    // debugPrint('home page has been activated');
    _pageController = PageController();
    super.initState();
  }

  @override
  void deactivate() {
    // debugPrint('home page has been deactivated');
    // _formProvider.dispose();

    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    _formProvider = Provider.of<FormProvider>(context);
    _formProvider.clearResult();
    _formProvider.setAssignmentId = widget.caseId;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    // debugPrint('supers  ${super.mounted} \n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initializeResponse(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>?> form) {
          var snapshot = form.data;
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (form.hasData && snapshot != null) {
            final data = Map<String, dynamic>.from(snapshot);

            return PageView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _getFormPages(data),
              onPageChanged: (currentPage) {},
            );
          } else if (snapshot == null) {
            return const Center(
              child: Text('Form will be displayed here'),
            );
          } else {
            return const Center(
              child: Text('Data not loaded'),
            );
          }
        },
      ),
    );
  }

  List<Widget> _getFormPages(Map<String, dynamic> form) {
    List<Widget> screen = [];

    List<dynamic> pageData = form['data'] ?? [];
    pageData.add({
      "name": "new page",
      "id": pageData.length,
      "fields": [
        {
          "widget": "signature",
          "id": 0,
          "label": "signature",
          "required": true,
        },
        {
          "widget": "text-input",
          "id": 1,
          "label": "text input",
          "required": true
        },
        {"widget": "address", "label": "address", "id": 2, "required": true},
      ],
    });

    screen.add(
      FormResultPreviewPage(
        provider: _formProvider,
        currentPage: pageData.length,
        totalPages: pageData.length + 1,
        pageController: _pageController,
        agencyId: _formProvider.agencyId,
      ),
    );
    _formProvider.setPagesData = pageData;

    return screen;
  }

  Future<Map<String, dynamic>?> initializeResponse() async {
    Map<String, dynamic>? snapData;
    try {
      snapData = await FirestoreServices.getFormDataById(widget.caseId);
      await _formProvider.initializeResponse();
      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(widget.caseId)
          .get()
          .then((value) {
        if (value.data() != null) {
          Map<String, dynamic> data = value.data()!;
          _formProvider.setAgencyId = data['agency'];
        }
      });
    } catch (error) {}
    return snapData;
  }
}
