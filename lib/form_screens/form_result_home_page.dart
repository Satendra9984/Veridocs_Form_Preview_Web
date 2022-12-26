import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../app_services/database/firestore_services.dart';
import 'initial_form_page.dart';

class FormResultHomePage extends StatefulWidget {
  final String caseId;
  const FormResultHomePage({
    required this.caseId,
    Key? key,
  }) : super(key: key);

  @override
  State<FormResultHomePage> createState() => _FormResultHomePageState();
}

class _FormResultHomePageState extends State<FormResultHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirestoreServices.getFormDataById(widget.caseId),
        builder: (context, AsyncSnapshot<Map<String, dynamic>?> form) {
          var snapshot = form.data;
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (form.hasData && snapshot != null) {
            final data = Map<String, dynamic>.from(snapshot);

            return InitialFormPageView(
              caseId: widget.caseId,
              pagesData: data,
              // isPreview: true,
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
}

/*

* */
