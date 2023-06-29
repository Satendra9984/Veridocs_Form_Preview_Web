import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FormProvider extends ChangeNotifier {
  Map<String, dynamic> _result = {};
  get getResult => _result;

  List<dynamic> _pages = [];
  get getPages => _pages;

  /// all pages ui data to be build (currently used in formResultPreviewPage)
  set setPagesData(List<dynamic> pagesData) {
    _pages = pagesData;
  }

  /// for the assignment id
  String _assignmentId = '';
  String get assignmentId => _assignmentId;
  set setAssignmentId(String id) {
    _assignmentId = id;
  }

  String _agencyId = '';
  String get agencyId => _agencyId;
  set setAgencyId(String id) {
    _agencyId = id;
  }

  updateData(
      {required String pageId,
      required String fieldId,
      String? rowId,
      String? columnId,
      String? type,
      required dynamic value}) {
    if (rowId != null && columnId != null) {
      _result['$pageId,$fieldId,$rowId,$columnId'] = value;
    } else {
      _result['$pageId,$fieldId'] = value;
    }
  }

  refreshData() {
    _result.removeWhere((key, value) => value == "");
  }

  clearResult() {
    _result = {};
    _agencyId = '';
    _assignmentId = '';
  }

  Future<void> initializeResponse() async {
    final snap = await FirebaseFirestore.instance
        .collection('assignments')
        .doc(_assignmentId)
        .collection('form_data')
        .doc('response')
        .get();

    if (snap.exists) {
      Map<String, dynamic>? data = snap.data();
      if (data != null && data.isNotEmpty) {
        _result = data;
        // debugPrint('initial provider data: $_result\n\n');
      }
    }
  }

  void deleteData(String keyG) {
    _result.removeWhere((key, value) => key == keyG);
    notifyListeners();
  }

  Future<void> saveDraftData() async {
    try {
      // debugPrint('saving draft data: $_result\n\n');
      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(assignmentId)
          .collection('form_data')
          .doc('response')
          .set(_result);
    } catch (e) {
      return;
    }
  }
}
