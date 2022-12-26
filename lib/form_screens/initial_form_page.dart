import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_provider/form_provider.dart';
import 'form_page.dart';

class InitialFormPageView extends StatefulWidget {
  final Map<String, dynamic> pagesData;
  final String caseId;
  const InitialFormPageView({
    Key? key,
    required this.pagesData,
    required this.caseId,
  }) : super(key: key);

  @override
  State<InitialFormPageView> createState() => _InitialFormPageViewState();
}

class _InitialFormPageViewState extends State<InitialFormPageView> {
  late final PageController _pageController;

  late FormProvider _formProvider;

  Future<void> initialize() async {
    await _formProvider.initializeResponse();
    // set agency Id
    await FirebaseFirestore.instance
        .collection('assignment')
        .doc(widget.caseId)
        .get()
        .then((value) {
      if (value.data() != null) {
        Map<String, dynamic> data = value.data()!;
        _formProvider.setAgencyId = data['agency'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    _formProvider = Provider.of<FormProvider>(context);
    _formProvider.setAssignmentId = widget.caseId;
    initialize();
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    _pageController.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _getFormPages(Map<String, dynamic> form) {
    List<Widget> screen = [];

    List<dynamic>? pageData = widget.pagesData['data'];
    if (pageData == null) {
      return screen;
    }
    for (int i = 0; i < pageData.length; i++) {
      // debugPrint('pageNumber --> ${i}\n');
      screen.add(
        FormPage(
          provider: _formProvider,
          singlePageData: pageData[i],
          currentPage: i,
          totalPages: pageData.length,
          pageController: _pageController,
          agencyId: _formProvider.agencyId,
        ),
      );
    }
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(),
      builder: (context, AsyncSnapshot<void> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return PageView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: _getFormPages(widget.pagesData),
            onPageChanged: (currentPage) {
              // debugPrint('page changed --> $currentPage}');
            },
          );
        }
      },
    );
  }
}
