import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HTTPRequests {
  static const String _BASE_URL = "http://veridocs.pythonanywhere.com/api/";

  static Future<Map<String, dynamic>?> sendGetRequest(String api) async {
    final uri = Uri.parse(_BASE_URL + api);
    final response = await http
        .get(uri, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendPostRequest(String api,
      {Map<String, dynamic>? body}) async {
    final uri = Uri.parse(_BASE_URL + api);
    final response = await http.post(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendDeleteRequest(
      String api, Map<String, dynamic> body) async {
    final uri = Uri.parse(_BASE_URL + api);
    final response = await http.delete(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendPutRequest(
      String api, Map<String, dynamic> body) async {
    final uri = Uri.parse(_BASE_URL + api);
    final response = await http.put(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
