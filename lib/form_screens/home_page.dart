import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../app_services/database/firestore_services.dart';
import 'initial_form_page.dart';

class FormPreviewHomePage extends StatefulWidget {
  final String agencyId;
  const FormPreviewHomePage({
    required this.agencyId,
    Key? key,
  }) : super(key: key);

  @override
  State<FormPreviewHomePage> createState() => _FormPreviewHomePageState();
}

class _FormPreviewHomePageState extends State<FormPreviewHomePage> {
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
      body: StreamBuilder(
        stream:
            FirebaseDatabase.instance.ref('forms/${widget.agencyId}').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> form) {
          var snapshot = form.data?.snapshot.value;
          // debugPrint('data-> $snapshot');
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (form.hasData && snapshot != null) {
            final data =
                Map<String, dynamic>.from(snapshot as Map<dynamic, dynamic>);
            debugPrint('data -> $data');
            Map<String, dynamic> newData = {
              'data': data['pages'],
            };
            return InitialFormPageView(
              pagesData: newData,
              caseId: widget.agencyId,
              isPreview: true,
            );
          } else if (snapshot == null) {
            // debugPrint('fine 75');
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
