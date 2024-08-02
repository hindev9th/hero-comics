
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/common/http_api.dart';
import 'package:test_app/models/response/response_home_model.dart';

Future<ResponseHome?> getListComics(int page) async {
  try{
    final response =
    await getRequest("/api/v2/home/filter?p=$page&value=all&extraData=");
    return JsonMapper.deserialize<ResponseHome>(response);
  }catch(e) {
    throw Exception('Failed to load data');
  }
}
