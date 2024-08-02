import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/enums/auth.dart';

const storage = FlutterSecureStorage();

Future<Map<String, dynamic>> getRequest(String url) async {
  final response =
  await http.get(Uri.parse(dotenv.env['PUBLIC_URL_API']! + url));
  if (response.statusCode == 200) {
    Map<String, dynamic> result =
    json.decode(utf8.decode(response.bodyBytes));
    if (!result['status']) {
      await storage.delete(key: AuthEnum.user.name);
    }
    return result;
  }

  throw Exception(
      'Failed to load data from $url. Status code: ${response.statusCode}');
}

Future<Map<String, dynamic>> postRequest(String url, String body, Map<String,dynamic>? headers) async {
  final response = await http.post(Uri.parse(dotenv.env['PUBLIC_URL_API']! + url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization' : "Bearer ${dotenv.env['PUBLIC_TOKEN_API']}",
        ...?headers
      },
      body: body);

  if (response.statusCode == 200) {
    Map<String, dynamic> result =
    json.decode(utf8.decode(response.bodyBytes));
    return result;
  }

  throw Exception(
      'Failed to load data from $url. Status code: ${response.statusCode}');
}