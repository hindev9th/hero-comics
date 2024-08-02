import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/models/response/response_list_comic_model.dart';

@JsonSerializable()
class ResponseApi {
  int? code;
  bool? status;
  ResponseApi(this.status,this.code);
}
