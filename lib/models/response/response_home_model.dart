import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/models/response_list_comic_model.dart';

@JsonSerializable()
class ResponseHome {
  ListComic? result;
  int? code;
  bool? status;
  ResponseHome(this.status,this.code,this.result);
}
