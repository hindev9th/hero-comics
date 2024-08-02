
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/common/http_api.dart';
import 'package:test_app/models/response/response_detail_comic.dart';

Future<ResponseDetail?> getListChapter(String id) async {
  try{
    final response =
    await getRequest("/api/comic/$id/chapter?offset=0&limit=-1&=");
    return JsonMapper.deserialize<ResponseDetail>(response);
  }catch(e) {
    throw Exception('Failed to load data $e');
  }
}
