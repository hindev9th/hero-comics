import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/enums/auth.dart';

class HttpApi {
  static final HttpApi _singleton = HttpApi._internal();
  late HttpApi database;

  factory HttpApi() {
    return _singleton;
  }

  HttpApi._internal();

  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> result =
          json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 401) {
        await storage.delete(key: AuthEnum.user.name);
      }
      return json.decode(utf8.decode(response.bodyBytes));
    }

    throw Exception(
        'Failed to load data from $url. Status code: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> post(String url, String body) async {
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> result =
          json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 401) {
        await storage.delete(key: AuthEnum.user.name);
      }
      return json.decode(utf8.decode(response.bodyBytes));
    }

    throw Exception(
        'Failed to load data from $url. Status code: ${response.statusCode}');
  }
}
