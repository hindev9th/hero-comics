import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/models/response/response_list_chapter.dart';

@JsonSerializable()
class ResponseDetail {
  ListChapters? result;
  int? code;
  bool? status;
  ResponseDetail(this.status,this.code,this.result);
}
