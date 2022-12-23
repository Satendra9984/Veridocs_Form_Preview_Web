import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_provider/form_provider.dart';
import 'form_page.dart';
import 'form_submit_screen.dart';

class InitialFormPageView extends StatefulWidget {
  final Map<String, dynamic> pagesData;
  final String caseId;
  final bool isPreview;
  const InitialFormPageView({
    Key? key,
    required this.pagesData,
    required this.caseId,
    required this.isPreview,
  }) : super(key: key);

  @override
  State<InitialFormPageView> createState() => _InitialFormPageViewState();
}

class _InitialFormPageViewState extends State<InitialFormPageView> {
  late final PageController _pageController;

  late FormProvider _formProvider;

  void initialize() async {
    await _formProvider.initializeResponse();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('page initial\n');
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
    // _pageController.dispose();
    // _formProvider.dispose();
    super.dispose();
  }

  List<Widget> _getFormPages(Map<String, dynamic> form) {
    List<Widget> screen = [];

    List<dynamic>? pageData = widget.pagesData['data'];
    if (pageData == null) {
      return screen;
    }
    for (int i = 0; i < pageData.length; i++) {
      debugPrint('pageNumber --> ${i}\n');
      screen.add(
        FormPage(
          provider: _formProvider,
          singlePageData: pageData[i],
          currentPage: i,
          totalPages: pageData.length + 1,
          pageController: _pageController,
        ),
      );
    }
    screen.add(
      FormSubmitPage(
        provider: _formProvider,
        currentPage: pageData.length,
        pageController: _pageController,
        totalPages: pageData.length + 1,
      ),
    );
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _formProvider.initializeResponse(),
        builder: (context, AsyncSnapshot<void> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
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
        });
  }
}
