import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class SPServices {
  Future<bool> checkIfExists(String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(caseId) != null);
  }

  Future<void> removeSavedAssignment(String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(caseId);
    prefs.remove('$caseId/form');
  }

  /// Getting the store SavedAssignment with the given CaseId
  Future<Map<String, dynamic>> getSavedAssignment(String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = json.decode(prefs.getString(caseId)!);
    return data;
  }

  Future<Map<String, dynamic>> getSavedAssignmentForm(String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = json.decode(prefs.getString('form$caseId')!);
    return data;
  }

  Future<List<String>?> getSavedAssignmentList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('savedAssignments');
  }

  /// Getting the list of SavedAssignment to display
  Stream<Map<String, dynamic>> getSaveAssignmentStream(String caseId) async* {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data;
    while (true) {
      data = jsonDecode(prefs.getString(caseId)!);
      yield data;
    }
  }

  Future setSavedAssignment(Map<String, dynamic> data, String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(caseId, jsonEncode(data));
  }

  Future<void> setSavedAssignmentForm(
      Map<String, dynamic> formData, String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('form$caseId', jsonEncode(formData));
  }

  /// setting the list of SavedAssignmentList Id's
  Future<void> setSavedAssignmentList(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedAssignments', list);
  }

  /// save data in local storage
  static Future<void> setData(String path, Uint8List bytesData) async {
    final prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(bytesData);
    await prefs.setString(path, base64Image);
  }

  /// get data from local storage
  static Future<Uint8List?> getData(String path) async {
    final prefs = await SharedPreferences.getInstance();
    String? imageString = prefs.getString(path);

    if (imageString != null) {
      Uint8List byteData = base64Decode(imageString);
      return byteData;
    }
    return null;
  }
}
